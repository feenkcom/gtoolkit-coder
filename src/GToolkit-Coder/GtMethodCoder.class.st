Class {
	#name : #GtMethodCoder,
	#superclass : #Object,
	#instVars : [
		'object',
		'class',
		'selector',
		'category',
		'sourceEditor',
		'patternEditor',
		'expanded',
		'highlighter',
		'methodSource'
	],
	#category : #'GToolkit-Coder-Coders'
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

	(methodSource notEmpty and: [ self patternSource isEmpty ])
		ifTrue: [ self buildSource ].

	^ GtCoderMethodElement new
		margin: (BlInsets all: 10);
		methodCoder: self;
		yourself
]

{ #category : #accessing }
GtMethodCoder >> bodySource [
	^ self sourceEditor text asString
]

{ #category : #'instance creation' }
GtMethodCoder >> bodyStylerClass [
	^ BrRBHighlightingMethodBodyTextStyler
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
				object: (GtCoderMethodsCollection forImplementors: symbol) asCoder;
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
	self patternSource: (self styledPatternTextFor: patternSource).
	index := self skipBlankLinesIn: methodSource at: index.
	originalBodySource := methodSource allButFirst: index - 1.
	text := originalBodySource asRopedText.
	text
		attributes:
			{BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	self sourceEditor text: text
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
GtMethodCoder >> clearSyntaxErrors: textEditor [
	textEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> context [
	^ nil
]

{ #category : #'actions - toolbar' }
GtMethodCoder >> contextActions [
	"Return a collection of contextual actions in the method coder. They are renderred separately from mainActions"
	<return: #Collection of: #GtCoderAction>
	
	^ #()
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
GtMethodCoder >> expanded: aBoolean [
	expanded := aBoolean
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

{ #category : #testing }
GtMethodCoder >> isForMethod: aCompiledMethod [
	^ class = aCompiledMethod methodClass and: [ selector = aCompiledMethod selector ]
]

{ #category : #'actions - toolbar' }
GtMethodCoder >> mainActions [
	"Return a collection of main actions in the method coder, for example save"
	<return: #Collection of: #GtCoderAction>
	
	^ { 
		GtCoderAction new
			title: 'Save' translated;
			icon: BrGlamorousIcons accept;
			action: [ self save ]
	}
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
	aStyler := self bodyStylerClass new.
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

{ #category : #private }
GtMethodCoder >> newPatternEditor [
	| editor |
	editor := BrTextEditor new.
	editor styler: self newPatternStyler.
	editor
		when: BrTextEditorInsertedEvent
			do: [ :event | 
			self updateStylerPattern.
			self clearSyntaxErrors: editor ];
		when: BrTextEditorDeletedEvent
			do: [ :event | 
			self updateStylerPattern.
			self clearSyntaxErrors: editor ].
	^ editor
]

{ #category : #'instance creation' }
GtMethodCoder >> newPatternStyler [
	| aStyler |
	aStyler := BrRBTextStyler new.
	aStyler classOrMetaClass: class.
	^ aStyler
]

{ #category : #'instance creation' }
GtMethodCoder >> newSourceEditor [
	<return: #BrTextEditor>
	| aSourceEditor |
	aSourceEditor := BrTextEditor new.
	aSourceEditor styler: self newBodyStyler.
	aSourceEditor
		when: BrTextEditorDeletedEvent do: [ :event | self clearSyntaxErrors: aSourceEditor ];
		when: BrTextEditorInsertedEvent do: [ :event | self clearSyntaxErrors: aSourceEditor ].
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

{ #category : #private }
GtMethodCoder >> patternEditor [
	^ patternEditor ifNil: [ patternEditor := self newPatternEditor ]
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
	^ (GtCoderMethodsCollection forReferences: aSymbol) asCoder
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
			^ (GtCoderMethodsCollection forClass: self classOrMetaClass andVariable: aString) asCoder ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ (GtCoderMethodsCollection forReferences: binding) asCoder ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> reportParseError: aString at: anInteger on: textEditor [
	| text position |
	text := textEditor text.
	position := anInteger - 1 max: 1.
	(text from: position to: position) attributes: {(GtMethodCoderErrorAttribute for: aString , ' ->')}.
	textEditor
		invalidate: position to: position;
		update: position to: position.
	textEditor moveCursorTo: position
]

{ #category : #actions }
GtMethodCoder >> requester [
	^ GtMethodCoderRequester on: self
]

{ #category : #actions }
GtMethodCoder >> save [
	| change |
	self validateSyntax
		ifFalse: [ ^ self ].
	change := category isNil
		ifTrue: [ RBAddMethodChange compile: self methodSource in: class for: self requester ]
		ifFalse: [ RBAddMethodChange
				compile: self methodSource
				in: class
				classified: category
				for: self requester ].
	self changeManager performChange: change
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
GtMethodCoder >> styledPatternTextFor: aString [
	| text |
	text := aString asRopedText.
	text monospace.
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

{ #category : #'event handling' }
GtMethodCoder >> updateMethod: aCompiledMethod [
	self forMethod: aCompiledMethod.
	self buildSource
]

{ #category : #private }
GtMethodCoder >> updateStylerPattern [
	self sourceEditor styler methodPatternSource: self patternEditor text asString.
	self sourceEditor styleText
]

{ #category : #private }
GtMethodCoder >> validateSyntax [
	[ GtPharoParser parse: self patternSource startingAt: GtPharoParser startingStateForMethodPattern ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self patternEditor.
			^ false ].
	[ GtPharoParser parse: self bodySource startingAt: GtPharoParser startingStateForMethodSequence ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self sourceEditor.
			^ false ].
	^ true
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
