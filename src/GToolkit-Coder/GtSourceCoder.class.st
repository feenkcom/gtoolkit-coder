Class {
	#name : #GtSourceCoder,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'sourceEditor',
		'expanded',
		'attributes',
		'addOns',
		'collapsedEditor'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtSourceCoder >> addOns [
	^ addOns
]

{ #category : #updating }
GtSourceCoder >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #accessing }
GtSourceCoder >> announcer [
	^ announcer
]

{ #category : #elements }
GtSourceCoder >> asElement [
	| expander |
	expander := BrExpander new.
	expander
		vFitContent;
		hMatchParent.
	expanded
		ifTrue: [ expander expand ].
	expander look: GtCoderExpanderLook new.
	expander header: [ self collapsedElement ].
	expander content: [ self sourceElement ].
	expander margin: (BlInsets all: 8).
	^ expander
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #actions }
GtSourceCoder >> browseClass: editorElement [
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
GtSourceCoder >> browseImplementors: editorElement [
	| symbol |
	symbol := self selectorAtCursor.
	symbol isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtCoderImplementorsFilter selector: symbol);
				sourceElement: editorElement)
]

{ #category : #actions }
GtSourceCoder >> browseReferences: editorElement [
	| filter |
	filter := self referencesFilterAtCursor.
	filter isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: filter;
				sourceElement: editorElement)
]

{ #category : #private }
GtSourceCoder >> classOrMetaClass [
	^ Object
]

{ #category : #private }
GtSourceCoder >> clearPreviousEvaluations [
	self sourceText
		clearAttributes: [ :each | 
			(each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute)
				or: [ each isKindOf: GtMethodCoderErrorAttribute ] ].
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtSourceCoder >> clearSyntaxErrors: textEditor [
	textEditor isNil
		ifTrue: [ ^ self ].
	textEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #ui }
GtSourceCoder >> collapsedEditor [
	^ collapsedEditor ifNil: [ collapsedEditor := self newCollapsedEditor ]
]

{ #category : #ui }
GtSourceCoder >> collapsedElement [
	| element |
	element := BrEditorElement new.
	element editor: self collapsedEditor.
	^ element
]

{ #category : #accessing }
GtSourceCoder >> collapsedSource [
	^ self collapsedText asString
]

{ #category : #accessing }
GtSourceCoder >> collapsedSource: aString [
	| text |
	text := aString asRopedText.
	self collapsedEditor text: text readonly.
	self styleCollapsedText.
]

{ #category : #ui }
GtSourceCoder >> collapsedStyler [
	^ nil
]

{ #category : #accessing }
GtSourceCoder >> collapsedText [
	^ self collapsedEditor text
]

{ #category : #private }
GtSourceCoder >> completionStrategy [
	^ self newCompletionStrategy
]

{ #category : #'actions - toolbar' }
GtSourceCoder >> contextActions [
	"Return a collection of contextual actions in the method coder. They are renderred separately from mainActions"

	<return: #Collection of: #GtCoderAction>
	^ addOns contextActions
]

{ #category : #private }
GtSourceCoder >> cursorPositionDo: aBlock [
	self sourceEditor cursor do: [ :each | ^ aBlock value: each position ]
]

{ #category : #private }
GtSourceCoder >> defaultTextAttributes [
	^ {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #private }
GtSourceCoder >> disabledTextAttributes [
	^ {(BlTextForegroundAttribute paint: BrGlamorousColors disabledButtonTextColor)}
]

{ #category : #actions }
GtSourceCoder >> evaluationRequester [
	^ GtMethodCoderEvaluationRequester on: self
]

{ #category : #accessing }
GtSourceCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtSourceCoder >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #ui }
GtSourceCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'initialize-release' }
GtSourceCoder >> initialize [
	super initialize.
	announcer := Announcer new.
	expanded := false.
	self initializeAddOns
]

{ #category : #'initialize-release' }
GtSourceCoder >> initializeAddOns [
	addOns := GtMethodCoderAddOns new.
	self initializeShortcuts.
]

{ #category : #'initialize-release' }
GtSourceCoder >> initializeShortcuts [
	addOns
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key m;
						build);
				action: [ :editorElement | self browseImplementors: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key n;
						build);
				action: [ :editorElement | self browseReferences: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key b;
						build);
				action: [ :editorElement | self browseClass: editorElement ])
]

{ #category : #testing }
GtSourceCoder >> isBuilt [
	^ true
]

{ #category : #'actions - toolbar' }
GtSourceCoder >> mainActions [
	"Return a collection of main actions in the method coder, for example save"

	<return: #Collection of: #GtCoderAction>
	^ addOns mainActions
]

{ #category : #accessing }
GtSourceCoder >> methodsCoder [
	^ self attributeNamed: #methodsCoder
]

{ #category : #accessing }
GtSourceCoder >> methodsCoder: aCoder [
	^ self attributeNamed: #methodsCoder put: aCoder
]

{ #category : #private }
GtSourceCoder >> newCollapsedEditor [
	^ BrTextEditor new
]

{ #category : #private }
GtSourceCoder >> newCompletionStrategy [
	| completionStrategy |
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: self classOrMetaClass.
	^ completionStrategy
]

{ #category : #ui }
GtSourceCoder >> newSourceEditor [
	| editor |
	editor := BrTextEditor new.
	self newSourceStyler ifNotNil: [ :styler | editor styler: styler ].
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ].
	^ editor
]

{ #category : #private }
GtSourceCoder >> newSourceStyler [
	^ nil
]

{ #category : #private }
GtSourceCoder >> nodeAtCursor [
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

{ #category : #private }
GtSourceCoder >> parserStartingState [
	^ GtPharoParser startingStateForMethodSequence
]

{ #category : #private }
GtSourceCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSubclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #private }
GtSourceCoder >> referencesFilterAtCursor [
	| node |
	node := self nodeAtCursor.
	[ node isNil ]
		whileFalse: [ (node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ self referencesFilterForVariable: node name source ].
			(node isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ self referencesFilterForSymbol: node asSymbol ].
			(node isKindOf: GtPharoMessageSendNode)
				ifTrue: [ node := node message ].
			(node isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ self referencesFilterForSymbol: node selector ].
			node := node parent ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> referencesFilterForSymbol: aSymbol [
	^ GtCoderReferencesFilter literal: aSymbol
]

{ #category : #private }
GtSourceCoder >> referencesFilterForVariable: aString [
	| index binding |
	index := self classOrMetaClass instVarIndexFor: aString.
	index > 0
		ifTrue: [ ^ GtCoderInstanceVariableReferenceFilter forClass: self classOrMetaClass andVariable: aString ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ GtCoderReferencesFilter literal: binding ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> reportParseError: aString at: anInteger on: textEditor [
	| text position |
	textEditor isNil
		ifTrue: [ ^ self ].
	text := textEditor text.
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	(text from: position to: position) attributes: {(GtMethodCoderErrorAttribute for: aString , ' ->')}.
	textEditor
		invalidate: position to: position;
		update: position to: position.
	textEditor moveCursorTo: position
]

{ #category : #actions }
GtSourceCoder >> requester [
	^ GtMethodCoderRequester on: self
]

{ #category : #private }
GtSourceCoder >> selectedSourceInterval [
	self sourceEditor selection do: [ :each | ^ each from + 1 to: each to ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> selectorAtCursor [
	^ self symbolFor: self nodeAtCursor
]

{ #category : #accessing }
GtSourceCoder >> source [
	^ self sourceText asString
]

{ #category : #accessing }
GtSourceCoder >> source: aString [
	| text |
	text := aString asRopedText.
	text attributes: self defaultTextAttributes.
	^ self sourceEditor text: text
]

{ #category : #private }
GtSourceCoder >> sourceAst [
	^ GtPharoParser parseWithErrors: self source startingAt: self parserStartingState
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChanged [
	self clearSyntaxErrors: self sourceEditor.
	self clearSyntaxErrors: self collapsedEditor.
	self updateCollapsedSource.
	self updateAddOns
]

{ #category : #private }
GtSourceCoder >> sourceEditor [
	<return: #BrTextEditor>

	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #ui }
GtSourceCoder >> sourceElement [
	| container element toolbar |
	container := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element := BrEditorElement new.
	addOns shortcuts do: [ :each | element addShortcut: (each copy action: [ each action cull: element ]) ].
	element
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element editor: self sourceEditor.
	(GtCompletionController on: element strategy: self completionStrategy) install.
	toolbar := GtCoderMethodActionsElement new
		methodCoder: self;
		padding:
			(BlInsets
				top: 0
				left: -3
				bottom: -3
				right: 0);
		margin: (BlInsets top: 5).
	container addChild: element.
	container addChild: toolbar.
	^ container
]

{ #category : #accessing }
GtSourceCoder >> sourceText [
	^ self sourceEditor text
]

{ #category : #private }
GtSourceCoder >> styleCollapsedText [
	| text |
	text := self collapsedEditor text text.
	self collapsedStyler ifNotNil: [ :styler | styler style: text ].
	self collapsedEditor text: text readonly
]

{ #category : #private }
GtSourceCoder >> styleSourceText [
	self sourceEditor styleText
]

{ #category : #updating }
GtSourceCoder >> styleText [
	self isBuilt
		ifFalse: [ ^ self ].
	self styleSourceText.
	self styleCollapsedText
]

{ #category : #private }
GtSourceCoder >> symbolFor: aNode [
	| current |
	aNode isNil
		ifTrue: [ ^ nil ].
	(aNode isKindOf: GtPharoSymbolLiteralNode)
		ifTrue: [ ^ aNode asSymbol ].
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current isKindOf: GtPharoMessageSendNode)
				ifTrue: [ current := current message ].
			(current isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ current selector ].
			current := current parent ].
	^ nil
]

{ #category : #updating }
GtSourceCoder >> updateAddOns [
	
]

{ #category : #'event handling' }
GtSourceCoder >> updateCollapsedSource [
	| firstLine |
	firstLine := (self sourceEditor text asString lines detect: [ :each | each notEmpty ] ifNone: [ '' ]) asRopedText.
	firstLine attributes: self disabledTextAttributes , self defaultTextAttributes.
	self collapsedSource: firstLine
]

{ #category : #private }
GtSourceCoder >> validateSyntax [
	[ GtPharoParser parse: self source startingAt: self parserStartingState ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self sourceEditor.
			self reportParseError: ex messageText at: ex tag position on: self collapsedEditor.
			^ false ].
	^ true
]

{ #category : #private }
GtSourceCoder >> variableAtCursor [
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
