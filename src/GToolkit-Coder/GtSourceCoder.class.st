Class {
	#name : #GtSourceCoder,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'sourceEditor',
		'expanded',
		'attributes',
		'addOns'
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
				object: (GtCoderMethodsCollection forImplementors: symbol) asCoder;
				sourceElement: editorElement)
]

{ #category : #actions }
GtSourceCoder >> browseReferences: editorElement [
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
GtSourceCoder >> classOrMetaClass [
	^ Object
]

{ #category : #private }
GtSourceCoder >> clearPreviousEvaluations [
	self sourceEditor text clearAttributes: [ :each | each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute ].
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

{ #category : #private }
GtSourceCoder >> collapsedEditor [
	^ nil
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

{ #category : #'actions - toolbar' }
GtSourceCoder >> mainActions [
	"Return a collection of main actions in the method coder, for example save"

	<return: #Collection of: #GtCoderAction>
	^ addOns mainActions
]

{ #category : #private }
GtSourceCoder >> newBodyStyler [
	^ nil
]

{ #category : #ui }
GtSourceCoder >> newSourceEditor [
	sourceEditor := BrTextEditor new.
	self newBodyStyler ifNotNil: [ :styler | sourceEditor styler: styler ].
	sourceEditor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ].
	^ sourceEditor
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
GtSourceCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSubclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #private }
GtSourceCoder >> referencesCoderAtCursor [
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
GtSourceCoder >> referencesCoderForSymbol: aSymbol [
	^ (GtCoderMethodsCollection forReferences: aSymbol) asCoder
]

{ #category : #private }
GtSourceCoder >> referencesCoderForVariable: aString [
	| index binding |
	index := self classOrMetaClass instVarIndexFor: aString.
	index > 0
		ifTrue: [ ^ (GtCoderMethodsCollection forClass: self classOrMetaClass andVariable: aString) asCoder ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ (GtCoderMethodsCollection forReferences: binding) asCoder ].
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

{ #category : #private }
GtSourceCoder >> sourceAst [
	^ GtPharoParser
		parseWithErrors: self sourceEditor text asString
		startingAt: GtPharoParser startingStateForMethodSequence
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChanged [
	self clearSyntaxErrors: self sourceEditor.
	self clearSyntaxErrors: self collapsedEditor.
	self updateAddOns
]

{ #category : #private }
GtSourceCoder >> sourceEditor [
	<return: #BrTextEditor>

	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #private }
GtSourceCoder >> symbolFor: aNode [
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

{ #category : #updating }
GtSourceCoder >> updateAddOns [
	
]

{ #category : #private }
GtSourceCoder >> validateSyntax [
	[ GtPharoParser parse: self sourceEditor text asString startingAt: GtPharoParser startingStateForMethodSequence ]
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
