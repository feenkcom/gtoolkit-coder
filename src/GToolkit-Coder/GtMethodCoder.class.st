Class {
	#name : #GtMethodCoder,
	#superclass : #Announcer,
	#instVars : [
		'object',
		'class',
		'category',
		'sourceEditor',
		'patternEditor',
		'expanded',
		'highlighter',
		'methodSource'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodCoder class >> forMethod: aCompiledMethod [
	^ self new
		forMethod: aCompiledMethod;
		yourself
]

{ #category : #'instance creation' }
GtMethodCoder class >> forObject: anObject andSelector: aSymbol [
	^ (self forMethod: anObject class >> aSymbol)
		object: anObject;
		yourself
]

{ #category : #elements }
GtMethodCoder >> addBodyShortcutsTo: editorElement [
	editorElement
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key d;
						build);
				action: [ self doItSelection ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key g;
						build);
				action: [ self doItAndGoSelection: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key m;
						build);
				action: [ self browseImplementors: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key n;
						build);
				action: [ self browseReferences: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key b;
						build);
				action: [ self browseClass: editorElement ])
]

{ #category : #elements }
GtMethodCoder >> asElement [
	| accordion header |

	(methodSource notEmpty and: [ self patternSource isEmpty ])
		ifTrue: [ self buildSource ].

	accordion := BrAccordion new.
	accordion margin: (BlInsets all: 10).
	accordion look: GtCoderMethodAccordionLook new.
	accordion stencil: [ self bodyElement margin: (BlInsets left: 5)].

	header := self patternButtonElement.
	header
		action: [ 
			accordion toggle.
			self expanded: accordion isExpanded ].

	accordion addChildFirst: header.
	expanded
		ifTrue: [ accordion toggle ].
	accordion userData at: #coder put: self.
	^ accordion
]

{ #category : #elements }
GtMethodCoder >> bodyElement [
	^ GtMethodBodyElement new
		initializeWith: self;
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal matchParent
		]
]

{ #category : #accessing }
GtMethodCoder >> bodySource [
	^ self sourceEditor text asString
]

{ #category : #actions }
GtMethodCoder >> browseClass: editorElement [
	| variable varName behavior |
	variable := self variableAtCursor.
	variable isNil
		ifTrue: [ ^ self ].
	varName := variable name value asSymbol.
	behavior := Smalltalk globals at: varName ifAbsent: [ ^ self ].
	behavior isBehavior
		ifFalse: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtClassCoder forClass: behavior);
				sourceElement: editorElement)
]

{ #category : #actions }
GtMethodCoder >> browseImplementors: editorElement [
	| symbol |
	symbol := self selectorAtCursor.
	symbol isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtMethodsCoder forImplementors: symbol);
				sourceElement: editorElement)
]

{ #category : #actions }
GtMethodCoder >> browseReferences: editorElement [
	| coder |
	coder := self referencesCoderAtCursor.
	coder isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: coder;
				sourceElement: editorElement)
]

{ #category : #private }
GtMethodCoder >> buildSource [
	| patternSource ast originalBodySource index text |
	ast := GtPharoParser parse: methodSource.
	index := self findSeparatorBetweenPatternAndBodyIn: ast.
	patternSource := methodSource copyFrom: 1 to: index - 1.
	index := self skipBlankLinesIn: methodSource at: index.
	originalBodySource := methodSource allButFirst: index - 1.
	text := originalBodySource asRopedText.
	text
		attributes:
			{BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	self sourceEditor text: text.
	self patternEditor text: patternSource asRopedText
]

{ #category : #elements }
GtMethodCoder >> categoryElement [
	^ (GtCoderDropdownStencil new
		initialItem: category;
		allItems: class organization categories asSortedCollection;
		asElement)
			constraintsDo: [ :c | c margin: (BlInsets all: 5) ]
]

{ #category : #actions }
GtMethodCoder >> changeManager [
	^ RBRefactoryChangeManager instance
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass [
	^ class
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass: aBehavior [
	class := aBehavior
]

{ #category : #private }
GtMethodCoder >> clearPatternSyntaxErrors [
	self patternEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> clearPreviousEvaluations [
	self sourceEditor text clearAttributes: [ :each | each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute ].
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtMethodCoder >> clearSyntaxErrors [
	self sourceEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> context [
	^ nil
]

{ #category : #private }
GtMethodCoder >> cursorPositionDo: aBlock [
	self sourceEditor cursor do: [ :each | ^ aBlock value: each position ]
]

{ #category : #actions }
GtMethodCoder >> doItAndGoSelection: editorElement [
	| source value |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	value := self evaluateSource: source.
	value == self
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: value;
				sourceElement: editorElement)
]

{ #category : #actions }
GtMethodCoder >> doItSelection [
	| source |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	self evaluateSource: source
]

{ #category : #elements }
GtMethodCoder >> dropDownElementWithItems: aCollection label: aString [
	^ GtCoderDropdownStencil new
		initialItem: aString;
		allItems: aCollection;
		asElement
]

{ #category : #private }
GtMethodCoder >> evaluateSource: aString [
	| value interval |
	self clearPreviousEvaluations.
	value := class compiler
		requestor: self evaluationRequester;
		source: aString;
		receiver: object;
		context: self context;
		failBlock: [ ^ self ];
		evaluate.
	interval := self selectedSourceInterval.
	self sourceEditor text
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new
				beNotOverwritableByStyler;
				result: value;
				paint: (Color fromHexString: #'90CAF9'))}
		from: interval last
		to: interval last.
	self sourceEditor
		invalidateAll;
		updateAll.
	^ value
]

{ #category : #actions }
GtMethodCoder >> evaluationRequester [
	^ GtMethodCoderEvaluationRequester on: self
]

{ #category : #accessing }
GtMethodCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtMethodCoder >> expanded: anObject [
	expanded := anObject
]

{ #category : #private }
GtMethodCoder >> findSeparatorBetweenPatternAndBodyIn: aMethodNode [
	| startIndex char source |
	source := aMethodNode completeSource.
	startIndex := aMethodNode pattern stopPosition + 1.
	[ startIndex <= source size and: [ (char := source at: startIndex) isSeparator and: [ char ~= Character cr ] ] ]
		whileTrue: [ startIndex := startIndex + 1 ].
	^ startIndex
]

{ #category : #'initialize-release' }
GtMethodCoder >> forMethod: aCompiledMethod [
	| selector |
	class := aCompiledMethod methodClass.
	selector := aCompiledMethod selector.
	category := class whichCategoryIncludesSelector: selector.
	methodSource := aCompiledMethod sourceCode
]

{ #category : #ui }
GtMethodCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #accessing }
GtMethodCoder >> highlighter [
	^ highlighter
]

{ #category : #accessing }
GtMethodCoder >> highlighter: anObject [
	highlighter := anObject
]

{ #category : #'initialize-release' }
GtMethodCoder >> initialize [
	super initialize.
	methodSource := ''.
	expanded := false
]

{ #category : #elements }
GtMethodCoder >> instClassElement [
	^ (GtCoderDropdownStencil new
		initialItem: (self classOrMetaClass isMeta
				ifTrue: [ 'class' ]
				ifFalse: [ 'instance' ]);
		allItems: #('instance' 'class');
		asElement)
			constraintsDo: [ :c | c margin: (BlInsets all: 5) ]
]

{ #category : #actions }
GtMethodCoder >> methodSource [
	^ self patternSource , String cr , self bodySource
]

{ #category : #'instance creation' }
GtMethodCoder >> newBodyStyler [
	"Create a text styler to be used by a method body editor"
	<return: #BlTextStyler>
	| aStyler |

	aStyler := BrRBHighlightingMethodBodyTextStyler new.
	aStyler classOrMetaClass: class.
	aStyler methodPatternSource: self patternSource.
	aStyler highlighter: highlighter.

	^ aStyler
]

{ #category : #'instance creation' }
GtMethodCoder >> newCompletionStrategy [
	| completionStrategy ast |
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: class.
	[ ast := GtPharoParser parseWithErrors: self patternSource.
	completionStrategy methodPattern: ast pattern ]
		on: Error
		do: [ :ex | ex return ].

	^ completionStrategy
]

{ #category : #'instance creation' }
GtMethodCoder >> newSourceEditor [
	| aSourceEditor |
	<return: #BrTextEditor>

	aSourceEditor := BrTextEditor new.
	aSourceEditor styler: self newBodyStyler.
	aSourceEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearSyntaxErrors ].
		
	^ aSourceEditor
]

{ #category : #private }
GtMethodCoder >> nodeAtCursor [
	self
		cursorPositionDo: [ :position | 
			[ | ast innerNode |
			ast := self sourceAst.
			ast
				withAllNodesDo: [ :node | 
					(position between: node startPosition and: node stopPosition)
						ifTrue: [ innerNode := node ] ].
			^ innerNode ]
				on: Error
				do: [ :ex | ex return ] ].
	^ nil
]

{ #category : #accessing }
GtMethodCoder >> object [
	^ object
]

{ #category : #accessing }
GtMethodCoder >> object: anObject [
	object := anObject
]

{ #category : #elements }
GtMethodCoder >> patternButtonElement [
	| header patternElement label editorElement styledPattern button bar |

	styledPattern := self styledPatternText.

	header := BrButton new.
	header background: Color white.
	header
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	bar := BlElement new.
	bar background: (Color gray alpha: 0.2).
	bar constraintsDo: [ :c |
		c horizontal exact: 10.
		c vertical matchParent ].
	header addChild: bar.

	patternElement := BlElement new.
	patternElement margin: (BlInsets left: 5).
	patternElement layout: (BlLinearLayout vertical).
	patternElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent.
			c linear vertical alignCenter ].
	self patternEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearPatternSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearPatternSyntaxErrors ].

	label := BlTextElement new.
	"label background: (Color red alpha: 0.2)."
	label text: styledPattern monospace.
	patternElement addChild: label.

	editorElement := BrEditorElement new.
	editorElement background: Color blue.
	editorElement editor: self patternEditor.
	self patternEditor text: styledPattern.
	editorElement
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 5).
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editorElement when: BlClickEvent do: [ :event | event consumed: true ].

	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons edit asElement;
		action: [ editorElement isVisible
				ifTrue: [ editorElement visibility: BlVisibility hidden.
					label visibility: BlVisibility visible ]
				ifFalse: [ editorElement visibility: BlVisibility visible.
					label visibility: BlVisibility hidden ] ];
		margin: (BlInsets top: 5 left: 10 bottom: 5 right: 10).

	"header addChild: button."
	header addChild: patternElement.
	"header addChild: self instClassElement.
	header addChild: self categoryElement.
	header addChild: self saveElement."
	^ header
]

{ #category : #private }
GtMethodCoder >> patternEditor [
	^ patternEditor ifNil: [ patternEditor := BrTextEditor new ]
]

{ #category : #accessing }
GtMethodCoder >> patternSource [
	^ self patternEditor text asString
]

{ #category : #accessing }
GtMethodCoder >> patternSource: aString [
	self patternEditor text: aString asRopedText
]

{ #category : #private }
GtMethodCoder >> referencesCoderAtCursor [
	| node |
	node := self nodeAtCursor.
	[ node isNil ]
		whileFalse: [ (node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ self referencesCoderForVariable: node name source ].
			(node isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ self referencesCoderForSymbol: node asSymbol ].
			(node isKindOf: GtPharoMessageSendNode)
				ifTrue: [ node := node message ].
			(node isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ self referencesCoderForSymbol: node selector ].
			node := node parent ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> referencesCoderForSymbol: aSymbol [
	^ (GtMethodsCoder forReferences: aSymbol)
		highlighter: (GtSelectorReferenceHighlighter forSelector: aSymbol);
		yourself
]

{ #category : #private }
GtMethodCoder >> referencesCoderForVariable: aString [
	| index binding methods |
	index := self classOrMetaClass instVarIndexFor: aString.
	index > 0
		ifTrue: [ methods := (self classOrMetaClass whichClassDefinesInstVar: aString) withAllSubclasses
				inject: OrderedCollection new
				into: [ :sum :each | 
					(each whichSelectorsAccess: aString) do: [ :sel | sum add: each >> sel ].
					sum ].
			^ (GtMethodsCoder forMethods: (GtMethodsCoder sortMethods: methods))
				highlighter: (GtVariableReferenceHighlighter forVariableName: aString);
				yourself ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ (GtMethodsCoder forReferences: binding)
				highlighter: (GtVariableReferenceHighlighter forVariableName: aString);
				yourself ].
	^ nil
]

{ #category : #actions }
GtMethodCoder >> requester [
	^ GtMethodCoderRequester on: self
]

{ #category : #actions }
GtMethodCoder >> save [
	| change |
	change := category isNil
		ifTrue: [ RBAddMethodChange compile: self methodSource in: class for: self requester ]
		ifFalse: [ RBAddMethodChange
				compile: self methodSource
				in: class
				classified: category
				for: self requester ].
	self changeManager performChange: change
]

{ #category : #elements }
GtMethodCoder >> saveElement [
	| button |
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons save asElement;
		action: [ self save ];
		constraintsDo: [ :c | c margin: (BlInsets all: 5) ].
	^ button
]

{ #category : #private }
GtMethodCoder >> selectedSource [
	self selectedSourceInterval ifNotNil: [ :interval | ^ (self sourceEditor text from: interval first to: interval last) asString ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> selectedSourceInterval [
	self sourceEditor selection do: [ :each | ^ each from + 1 to: each to ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> selectorAtCursor [
	^ self symbolFor: self nodeAtCursor
]

{ #category : #private }
GtMethodCoder >> skipBlankLinesIn: source at: startIndex [
	| char index |
	index := startIndex.
	[ index <= source size and: [ (char := source at: index) = Character cr or: [ char = Character lf ] ] ]
		whileTrue: [ index := index + 1 ].
	^ index
]

{ #category : #private }
GtMethodCoder >> sourceAst [
	^ GtPharoParser
		parseWithErrors: self sourceEditor text asString
		startingAt: GtPharoParser startingStateForMethodSequence
]

{ #category : #private }
GtMethodCoder >> sourceEditor [
	<return: #BrTextEditor>

	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #private }
GtMethodCoder >> styledPatternText [
	| text |
	text := self patternSource asRopedText.
	^ BrRBTextStyler new
		classOrMetaClass: class;
		style: text
]

{ #category : #private }
GtMethodCoder >> symbolFor: aNode [
	| current |
	aNode isNil
		ifTrue: [ ^ nil ].
	(aNode isKindOf: GtPharoSymbolLiteralNode)
		ifTrue: [ aNode asSymbol ].
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current isKindOf: GtPharoMessageSendNode)
				ifTrue: [ current := current message ].
			(current isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ current selector ].
			current := current parent ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> variableAtCursor [
	self
		cursorPositionDo: [ :position | 
			[ | ast |
			ast := self sourceAst.
			ast
				withAllNodesOfType: GtPharoVariableNode
				do: [ :node | 
					(position between: node startPosition and: node stopPosition)
						ifTrue: [ ^ node ] ] ]
				on: Error
				do: [ :ex | ex return ] ].
	^ nil
]
