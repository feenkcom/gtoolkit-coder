Class {
	#name : #GtCoderModel,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'expanded',
		'attributes',
		'addOns',
		'addOnCommand',
		'addOnMonitor'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #elements }
GtCoderModel >> addCollapsedShortcutsTo: anElement [
	addOns collapsedShortcuts
		do: [ :each | 
			anElement
				addShortcut: (each copy action: [ each action cull: anElement ]) ]
]

{ #category : #updating }
GtCoderModel >> addOnChanged: aSymbol [
	aSymbol = #mainActions
		ifTrue: [ self announce: (GtCoderMainActionsChanged new coder: self) ].
	aSymbol = #contextActions
		ifTrue: [ self announce: (GtCoderContextActionsChanged new coder: self) ]
]

{ #category : #accessing }
GtCoderModel >> addOns [
	^ addOns
]

{ #category : #'initialize-release' }
GtCoderModel >> addOnsClass [
	^ GtCoderAddOns
]

{ #category : #elements }
GtCoderModel >> addShortcutsTo: anElement [
	addOns shortcuts
		do: [ :each | anElement addShortcut: each ]
]

{ #category : #updating }
GtCoderModel >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #accessing }
GtCoderModel >> announcer [
	^ announcer
]

{ #category : #elements }
GtCoderModel >> asElement [
	^ GtExpandableCoderElement new
		coder: self;
		yourself
]

{ #category : #'accessing-attributes' }
GtCoderModel >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtCoderModel >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtCoderModel >> attributeNamed: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock ]
		ifFalse: [ anAbsentBlock value ]
]

{ #category : #'accessing-attributes' }
GtCoderModel >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtCoderModel >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #elements }
GtCoderModel >> breadcrumbNamedActions [
	^ #()
]

{ #category : #accessing }
GtCoderModel >> coders [
	^ self attributeNamed: #coders
]

{ #category : #accessing }
GtCoderModel >> coders: aCoders [
	^ self attributeNamed: #coders put: aCoders
]

{ #category : #elements }
GtCoderModel >> collapsedEditorElement [
	self subclassResponsibility
]

{ #category : #private }
GtCoderModel >> context [
	^ nil
]

{ #category : #'actions - toolbar' }
GtCoderModel >> contextActions [
	"Return a collection of contextual actions in the coder. They are renderred separately from mainActions"

	<return: #Collection of: #GtCoderAction>
	^ addOns contextActions
]

{ #category : #'actions - toolbar' }
GtCoderModel >> contextMenuActions [
	<return: #Collection of: #GtCoderAction>
	^ addOns contextMenuActions
]

{ #category : #accessing }
GtCoderModel >> expanded [
	^ expanded
]

{ #category : #accessing }
GtCoderModel >> expanded: aBoolean [
	aBoolean = expanded
		ifTrue: [ ^ self ].
	expanded := aBoolean.
	self expandedUpdated.
	self announce: (GtCoderExpandedChanged new coder: self)
]

{ #category : #elements }
GtCoderModel >> expandedEditorElement [
	self subclassResponsibility
]

{ #category : #private }
GtCoderModel >> expandedUpdated [
]

{ #category : #ui }
GtCoderModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #ui }
GtCoderModel >> gtViewContextActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewContextActionsFor: aView ]
]

{ #category : #ui }
GtCoderModel >> gtViewKeybindingsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewKeybindingsFor: aView ]
]

{ #category : #ui }
GtCoderModel >> gtViewMainActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewMainActionsFor: aView ]
]

{ #category : #testing }
GtCoderModel >> hasObjectAttribute [
	self 
		attributeNamed: #object 
		ifAbsent: [ ^ false ].
	^ true
]

{ #category : #initialization }
GtCoderModel >> initialize [
	super initialize.
	announcer := Announcer new.
	expanded := false.
	addOnMonitor := Monitor new.
	self initializeAddOns
]

{ #category : #'initialize-release' }
GtCoderModel >> initializeAddOns [
	addOns := self addOnsClass new.
	self initializeShortcuts
]

{ #category : #'initialize-release' }
GtCoderModel >> initializeShortcuts [
	
]

{ #category : #'actions - toolbar' }
GtCoderModel >> mainActions [
	"Return a collection of main actions in the coder, for example save"

	<return: #Collection of: #GtCoderAction>
	^ addOns mainActions
]

{ #category : #elements }
GtCoderModel >> previewElement [
	^ self asElement
]

{ #category : #'accessing-attributes' }
GtCoderModel >> removeAttributeNamed: aSymbol [
	attributes isNil
		ifTrue: [ ^ self ].
	attributes removeKey: aSymbol ifAbsent: [  ]
]

{ #category : #scripting }
GtCoderModel >> requestFocus [
	self announce: (GtCoderRequestFocus new coder: self)
]

{ #category : #elements }
GtCoderModel >> stylerView: anElement [

]

{ #category : #subscriptions }
GtCoderModel >> subscribeToSystem [
	"do nothing"
]

{ #category : #private }
GtCoderModel >> terminateAddOnsCommand [
	addOnCommand isNil
		ifTrue: [ ^ self ].
	addOnCommand terminate.
	addOnCommand := nil
]

{ #category : #subscriptions }
GtCoderModel >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #'api - navigation' }
GtCoderModel >> updateNavigation: aGtCoderNavigationPackagesTagsClassesModel [
]
