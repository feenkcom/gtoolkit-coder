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

{ #category : #'private - addons' }
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

{ #category : #'private - addons' }
GtCoderModel >> addOnsClass [
	^ GtCoderAddOns
]

{ #category : #'api - announcer' }
GtCoderModel >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #'api - announcer' }
GtCoderModel >> announcer [
	<return: #Announcer>

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

{ #category : #'api - attributes' }
GtCoderModel >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'api - attributes' }
GtCoderModel >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'api - attributes' }
GtCoderModel >> attributeNamed: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock ]
		ifFalse: [ anAbsentBlock value ]
]

{ #category : #'api - attributes' }
GtCoderModel >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'api - attributes' }
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

{ #category : #'api - actions' }
GtCoderModel >> contextActions [
	"Return a collection of contextual actions in the coder. They are renderred separately from mainActions"
	<return: #Collection of: #GtCoderAction>

	^ addOns contextActions
]

{ #category : #'api - actions' }
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
	<return: #Boolean>

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

{ #category : #'gt-extensions' }
GtCoderModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'gt-extensions' }
GtCoderModel >> gtViewContextActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewContextActionsFor: aView ]
]

{ #category : #'gt-extensions' }
GtCoderModel >> gtViewKeybindingsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewKeybindingsFor: aView ]
]

{ #category : #'gt-extensions' }
GtCoderModel >> gtViewMainActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewMainActionsFor: aView ]
]

{ #category : #initialization }
GtCoderModel >> initialize [
	super initialize.
	announcer := Announcer new.
	expanded := false.
	addOnMonitor := Monitor new.

	self initializeAddOns
]

{ #category : #initialization }
GtCoderModel >> initializeAddOns [
	addOns := self addOnsClass new.
	self initializeShortcuts
]

{ #category : #initialization }
GtCoderModel >> initializeShortcuts [
	
]

{ #category : #'api - actions' }
GtCoderModel >> mainActions [
	"Return a collection of main actions in the coder, for example save"
	<return: #Collection of: #GtCoderAction>

	^ addOns mainActions
]

{ #category : #elements }
GtCoderModel >> previewElement [
	"Return a preview element for the Spotter"
	<return: #BlElement>

	^ self asElement
]

{ #category : #'api - attributes' }
GtCoderModel >> removeAttributeNamed: aSymbol [
	attributes isNil
		ifTrue: [ ^ self ].
	attributes removeKey: aSymbol ifAbsent: [  ]
]

{ #category : #elements }
GtCoderModel >> requestFocus [
	self announce: (GtCoderRequestFocus new coder: self)
]

{ #category : #'api - addons' }
GtCoderModel >> requestUpdateAddOns [
	"Request addons to update due to some environmental changes (similar to requesting text to restyle).
	It is a responsibility of the Coder's Element to start the actual addon update (${method:GtCoderModel>>#updateAddOnsFrom:}$) which may happen in
	a background thread, that is why we can not start the update directly - we must have a reference to the element"

	addOns requestUpdate.
	self announce: (GtCoderAddOnsUpdateRequest new coder: self)
]

{ #category : #'api - addons' }
GtCoderModel >> shortcuts [
	<return: #Collection of: #BrTextEditorShortcut>

	^ addOns shortcuts
]

{ #category : #'api - addons' }
GtCoderModel >> shouldAddOnsBeUpdated [
	"Return true if addons should be updated, false otherwise. When a Coder Model is attached to the corresponding Element
	that element should check if addons need to be updated and if it is the case start the update with the help of ${method:GtCoderModel>>#updateAddOnsFrom:}$"
	<return: #Boolean>

	^ addOns shouldBeUpdated
]

{ #category : #subscriptions }
GtCoderModel >> subscribeToSystem [
	"do nothing"
]

{ #category : #subscriptions }
GtCoderModel >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #'api - addons' }
GtCoderModel >> updateAddOnsFrom: anElement [
	"Start the update of the addons in a context of a given element"
]
