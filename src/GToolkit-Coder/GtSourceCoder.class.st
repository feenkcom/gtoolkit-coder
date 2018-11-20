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
	addOns := GtMethodCoderAddOns new
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
