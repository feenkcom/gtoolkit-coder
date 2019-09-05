Class {
	#name : #GtCoder,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'expanded',
		'attributes',
		'addOns'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoder >> addOns [
	^ addOns
]

{ #category : #elements }
GtCoder >> addShortcutsTo: anElement [
	addOns shortcuts
		do: [ :each | 
			anElement
				addShortcut: (each copy action: [ each action cull: anElement ]) ]
]

{ #category : #updating }
GtCoder >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #accessing }
GtCoder >> announcer [
	^ announcer
]

{ #category : #elements }
GtCoder >> asElement [
	^ GtCoderElement new
		coder: self;
		yourself
]

{ #category : #'accessing-attributes' }
GtCoder >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtCoder >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtCoder >> attributeNamed: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock ]
		ifFalse: [ anAbsentBlock value ]
]

{ #category : #'accessing-attributes' }
GtCoder >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtCoder >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #elements }
GtCoder >> breadcrumbNamedActions [
	^ #()
]

{ #category : #accessing }
GtCoder >> coders [
	^ self attributeNamed: #coders
]

{ #category : #accessing }
GtCoder >> coders: aCoders [
	^ self attributeNamed: #coders put: aCoders
]

{ #category : #elements }
GtCoder >> collapsedEditorElement [
	self subclassResponsibility
]

{ #category : #private }
GtCoder >> context [
	^ nil
]

{ #category : #'actions - toolbar' }
GtCoder >> contextActions [
	"Return a collection of contextual actions in the coder. They are renderred separately from mainActions"

	<return: #Collection of: #GtCoderAction>
	^ addOns contextActions
]

{ #category : #accessing }
GtCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtCoder >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #elements }
GtCoder >> expandedEditorElement [
	self subclassResponsibility
]

{ #category : #ui }
GtCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #ui }
GtCoder >> gtViewContextActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewContextActionsFor: aView ]
]

{ #category : #ui }
GtCoder >> gtViewKeybindingsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewKeybindingsFor: aView ]
]

{ #category : #ui }
GtCoder >> gtViewMainActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewMainActionsFor: aView ]
]

{ #category : #testing }
GtCoder >> hasObjectAttribute [
	self 
		attributeNamed: #object 
		ifAbsent: [ ^ false ].
	^ true
]

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	announcer := Announcer new.
	expanded := false.
	self initializeAddOns
]

{ #category : #'initialize-release' }
GtCoder >> initializeAddOns [
	addOns := GtCoderAddOns new.
	self initializeShortcuts
]

{ #category : #'initialize-release' }
GtCoder >> initializeShortcuts [
	
]

{ #category : #'actions - toolbar' }
GtCoder >> mainActions [
	"Return a collection of main actions in the coder, for example save"

	<return: #Collection of: #GtCoderAction>
	^ addOns mainActions
]

{ #category : #updating }
GtCoder >> refreshForChanges [
	addOns
		changesDo: [ :each | 
			each = #mainActions
				ifTrue: [ self announce: (GtCoderMainActionsChanged new coder: self) ].
			each = #contextActions
				ifTrue: [ self announce: (GtCoderContextActionsChanged new coder: self) ] ].
	addOns clearChanges
]

{ #category : #elements }
GtCoder >> stylerView: anElement [

]

{ #category : #subscriptions }
GtCoder >> subscribeToSystem [
	"do nothing"
]

{ #category : #subscriptions }
GtCoder >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
