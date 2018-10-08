Class {
	#name : #GtMethodCoder,
	#superclass : #Announcer,
	#instVars : [
		'object',
		'class',
		'category',
		'sourceEditor',
		'patternEditor',
		'highlighter'
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
						key: Key m;
						build);
				action: [ self browseImplementors ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key n;
						build);
				action: [ self browseReferences ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key b;
						build);
				action: [ self browseClass ])
]

{ #category : #elements }
GtMethodCoder >> asElement [
	| accordion header |
	accordion := BrAccordion new.
	accordion look: BrGlamorousAccordionLook new.
	accordion margin: (BlInsets all: 5).
	accordion stencil: [ self bodyElement ].
	header := self patternButtonElement.
	header action: [ accordion toggle ].
	accordion addChildFirst: header.
	^ accordion
]

{ #category : #elements }
GtMethodCoder >> bodyElement [
	| completionStrategy completionController editorElement ast |
	sourceEditor styler: self bodyStyler.
	sourceEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearSyntaxErrors ].
	editorElement := BrEditorElement new.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	self addBodyShortcutsTo: editorElement.
	editorElement editor: sourceEditor.
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: class.
	[ ast := GtPharoParser parseWithErrors: self patternSource.
	completionStrategy methodPattern: ast pattern ]
		on: Error
		do: [ :ex | ex return ].
	completionController := GtCompletionController on: editorElement strategy: completionStrategy.
	completionController install.
	^ editorElement
]

{ #category : #accessing }
GtMethodCoder >> bodySource [
	^ sourceEditor text asString
]

{ #category : #elements }
GtMethodCoder >> bodyStyler [
	| styler |
	styler := BrRBHighlightingMethodBodyTextStyler new.
	styler classOrMetaClass: class.
	styler methodPatternSource: self patternSource.
	styler highlighter: highlighter.
	^ styler
]

{ #category : #actions }
GtMethodCoder >> browseClass [
	| variable varName behavior |
	variable := self variableAtCursor.
	variable isNil
		ifTrue: [ ^ self ].
	varName := variable name value asSymbol.
	behavior := Smalltalk globals at: varName ifAbsent: [ ^ self ].
	behavior isBehavior
		ifFalse: [ ^ self ].
	self announce: (GtCoderDrillDownAnnouncement forCoder: (GtClassCoder forClass: behavior))
]

{ #category : #actions }
GtMethodCoder >> browseImplementors [
	| symbol |
	symbol := self selectorAtCursor.
	symbol isNil
		ifTrue: [ ^ self ].
	self announce: (GtCoderDrillDownAnnouncement forCoder: (GtMethodsCoder forImplementors: symbol))
]

{ #category : #actions }
GtMethodCoder >> browseReferences [
	| coder |
	coder := self referencesCoderAtCursor.
	coder isNil
		ifTrue: [ ^ self ].
	self announce: (GtCoderDrillDownAnnouncement forCoder: coder)
]

{ #category : #elements }
GtMethodCoder >> categoryElement [
	| element |
	element := self dropDownElementWithItems: class organization categories asSortedCollection label: category.
	element constraintsDo: [ :c | c margin: (BlInsets all: 5) ].
	^ element
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
	patternEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> clearSyntaxErrors [
	sourceEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> cursorPositionDo: aBlock [
	self sourceEditor cursor do: [ :each | ^ aBlock value: each position ]
]

{ #category : #actions }
GtMethodCoder >> doItSelection [
	| source value result |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	value := class compiler
		requestor: self evaluationRequester;
		source: source;
		receiver: object;
		evaluate.
	result := GtCoderEvaluationAnnouncement forCoder: self result: value.
	self announce: result
]

{ #category : #elements }
GtMethodCoder >> dropDownElementWithItems: aCollection label: aString [
	| element arrow size arrowHeight arrowWidth listElement overlay index |
	overlay := self newPopupElement.
	listElement := self dropDownList: aCollection.
	index := aCollection indexOf: aString.
	index > 0
		ifTrue: [ listElement selectOne: index.
			listElement children first scrollToPosition: index ].
	listElement
		when: BlFocusOutEvent
		do: [ :event | 
			overlay isAttachedToSceneGraph
				ifTrue: [ overlay
						detach;
						removeFromParent ] ].
	overlay addChild: listElement.
	size := 100 @ 20.
	arrowHeight := size y - 10.
	arrowWidth := (arrowHeight * 2 sqrt) rounded.
	(arrow := BlElement new)
		size: arrowWidth @ arrowHeight;
		geometry:
			(BlPolygon
				vertices:
					{(0 @ 0).
					(arrowWidth @ 0).
					((arrowWidth / 2) rounded @ arrowHeight)});
		background: (Color veryLightGray alpha: 0.5);
		relocate: (size x - arrowWidth + 5) @ ((size y - arrowHeight) / 2 + 1) rounded;
		yourself.
	(element := BlTextElement new)
		text: (aString ifNil: [ '' ]) asRopedText;
		size: size;
		border: (BlBorder paint: Color veryLightGray width: 2);
		padding:
			(BlInsets
				top: 4
				left: 10
				bottom: 0
				right: 6);
		background: Color white;
		geometry: (BlRectangle cornerRadius: 12);
		when: BlClickEvent
			do: [ :event | 
			overlay isAttachedToSceneGraph
				ifTrue: [ overlay
						detach;
						removeFromParent ]
				ifFalse: [ element space root addChild: overlay.
					listElement requestFocus ].
			event consumed: true ];
		when: BlMouseOutEvent do: [ :event | element background: Color white ];
		when: BlMouseOverEvent do: [ :event | element background: Color veryLightGray ];
		addChild: arrow.
	overlay attachTo: element.
	^ element
]

{ #category : #elements }
GtMethodCoder >> dropDownList: items [
	^ BrSimpleList new
		lookDo: [ :aLook | 
			aLook listElement
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal matchParent.
					c maxHeight: 200 ] ];
		background: Color white;
		border: (BlBorder paint: Color lightGray width: 1);
		padding: (BlInsets all: 2);
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ];
		display: items;
		stencil: [ :each :anIndex | 
			BlTextElement new
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				text: (each displayString asRopedText thin monospace fontSize: 12) ]
]

{ #category : #elements }
GtMethodCoder >> editElement [
	| button |
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons edit asElement;
		action: [ self edit ];
		constraintsDo: [ :c | 
			c
				margin:
					(BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10) ].
	^ button
]

{ #category : #actions }
GtMethodCoder >> evaluationRequester [
	^ GtMethodCoderEvaluationRequester on: self
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
	| source index patternSource originalBodySource text ast selector |
	class := aCompiledMethod methodClass.
	selector := aCompiledMethod selector.
	category := class whichCategoryIncludesSelector: selector.
	source := aCompiledMethod sourceCode.
	ast := GtPharoParser parse: source.
	index := self findSeparatorBetweenPatternAndBodyIn: ast.
	patternSource := source copyFrom: 1 to: index - 1.
	index := self skipBlankLinesIn: source at: index.
	originalBodySource := source allButFirst: index - 1.
	text := originalBodySource asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	sourceEditor text: text.
	patternEditor text: patternSource asRopedText
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
	sourceEditor := BrTextEditor new.
	patternEditor := BrTextEditor new.
]

{ #category : #elements }
GtMethodCoder >> instClassElement [
	| element |
	element := self
		dropDownElementWithItems: #('instance' 'class')
		label:
			(self classOrMetaClass isMeta
				ifTrue: [ 'class' ]
				ifFalse: [ 'instance' ]).
	element constraintsDo: [ :c | c margin: (BlInsets all: 5) ].
	^ element
]

{ #category : #actions }
GtMethodCoder >> methodSource [
	^ self patternSource , String cr , self bodySource
]

{ #category : #elements }
GtMethodCoder >> newPopupElement [
	^ GtDropDownPopupElement new
		layout: BlLinearLayout vertical;
		background: Color red;
		constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal exact: 100 ]
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
	| header patternElement label editorElement styledPattern button |
	styledPattern := self styledPatternText.
	header := BrButton new.
	header
		layout: (BlGridLayout horizontal cellSpacing: 0);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	patternElement := BlElement new.
	patternElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c frame vertical alignCenter ].
	patternEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearPatternSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearPatternSyntaxErrors ].
	label := BlTextElement new.
	label text: styledPattern.
	label
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 5).
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	patternElement addChild: label.
	editorElement := BrEditorElement new.
	editorElement editor: patternEditor.
	patternEditor text: styledPattern.
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
	editorElement visibility: BlVisibility hidden.
	patternElement addChild: editorElement.
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons edit asElement;
		action: [ editorElement isVisible
				ifTrue: [ editorElement visibility: BlVisibility hidden.
					label visibility: BlVisibility visible ]
				ifFalse: [ editorElement visibility: BlVisibility visible.
					label visibility: BlVisibility hidden ] ];
		constraintsDo: [ :c1 | 
			c1
				margin:
					(BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10) ].
	header addChild: button.
	header addChild: patternElement.
	header addChild: self instClassElement.
	header addChild: self categoryElement.
	header addChild: self saveElement.
	^ header
]

{ #category : #private }
GtMethodCoder >> patternEditor [
	^ patternEditor
]

{ #category : #accessing }
GtMethodCoder >> patternSource [
	^ patternEditor text asString
]

{ #category : #accessing }
GtMethodCoder >> patternSource: aString [
	patternEditor text: aString asRopedText
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
	sourceEditor selection do: [ :each | ^ (sourceEditor text from: each from + 1 to: each to) asString ].
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
	^ sourceEditor
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
