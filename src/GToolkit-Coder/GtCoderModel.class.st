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

{ #category : #'api - addons' }
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

{ #category : #'api - addons' }
GtCoderModel >> addOns [
	<return: #GtCoderAddOns>

	^ addOns
]

{ #category : #'initialize-release' }
GtCoderModel >> addOnsClass [
	^ GtCoderAddOns
]

{ #category : #'api - addons' }
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
	^ self elementClass new
		coder: self;
		yourself
]

{ #category : #elements }
GtCoderModel >> asExpandedOnlyElement [
	"Create an element for just the expanded coder without expander"

	^ GtExpandedOnlyCoderElement new
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

{ #category : #elements }
GtCoderModel >> coderLook [
	^ self attributeNamed: #coderLook ifAbsent: [  ]
]

{ #category : #elements }
GtCoderModel >> coderLook: aLook [
	^ self attributeNamed: #coderLook put: aLook
]

{ #category : #accessing }
GtCoderModel >> coders [
	^ self attributeNamed: #coders
]

{ #category : #accessing }
GtCoderModel >> coders: aCoders [
	^ self attributeNamed: #coders put: aCoders
]

{ #category : #private }
GtCoderModel >> context [
	^ nil
]

{ #category : #'api - accessing actions' }
GtCoderModel >> contextActions [
	"Return a collection of contextual actions in the coder. They are renderred separately from mainActions"

	<return: #Collection of: #GtCoderAction>
	^ addOns contextActions
]

{ #category : #'api - accessing actions' }
GtCoderModel >> contextMenuActions [
	<return: #Collection of: #GtCoderAction>
	^ addOns contextMenuActions
]

{ #category : #elements }
GtCoderModel >> elementClass [
	^ GtExpandableCoderElement
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

{ #category : #'api - accessing actions' }
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

{ #category : #'api - addons' }
GtCoderModel >> requestAddOnsUpdate [
	"Request addons to update due to some environmental changes (similar to requesting text to restyle)"

	addOns requestUpdate
]

{ #category : #scripting }
GtCoderModel >> requestFocus [
	self announce: (GtCoderRequestFocus new coder: self)
]

{ #category : #elements }
GtCoderModel >> shortcuts [
	<return: #Collection of: #BlShortcut>

	^ addOns shortcuts
]

{ #category : #'api - addons' }
GtCoderModel >> shouldAddOnsBeUpdated [
	"Return true if addons should be updated, false otherwise"
	<return: #Boolean>

	^ addOns shouldBeUpdated
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

{ #category : #'api - addons' }
GtCoderModel >> updateAddOnsFrom: anElement [
	"Start the update of the addons in a context of a given element"
]
