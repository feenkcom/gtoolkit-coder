"
! Coder
Is an abstract model of a moldable Coder - a tool for creating and manipulating code.

As a root entity in the hierarchy of coders ${class:GtCoderModel}$ do not make any assumptions on the way code is represented. In fact in contrast to ${class:GtSourceCoder}$ , it does not know anything about code.
!! Moldability
Coder is designed to be easily adapted by the users in order to be used in various contexts through so called ==add-ons== ${class:GtCoderAddOns}$. Its subclasses can override ${method:GtCoderModel>>#addOnsClass}$ to allow coder to have extra kinds of addons or ${method:GtCoderModel>>#initializeAddOns}$ to customize the default add-ons.
!! Add-ons
By default there are the following types of add-ons:
1) ${method:GtCoderAddOns>>#mainActions}$ that are typically added as a button at the bottom of a coder. One of such actions is usually ==Save==. Main actions are usually static and should not depend on the source code or context of the coder.
2) ${method:GtCoderAddOns>>#contextActions}$ appear near main actions and are usually contextual, which means they depend on the source code. One example may be a ==Play== button that appears when a method is marked with ==<gtExample>== pragma.
3) ${method:GtCoderAddOns>>#contextMenuActions}$is a set of actions that appear in a context menu usually triggered with a right mouse click. ==Copy / Cut / Paste== are typical examples of context menu actions.
4) ${method:GtCoderAddOns>>#shortcuts}$are actions that are triggered due to a pressed key combination when a coder has focus.
"
Class {
	#name : #GtCoderModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
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

	addOns ifNil: [ self initializeAddOns ].
	^ addOns
]

{ #category : #'private - addons' }
GtCoderModel >> addOnsClass [
	^ GtCoderAddOns
]

{ #category : #'api - announcer' }
GtCoderModel >> announcer [
	<return: #Announcer>

	^ announcer
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

	^ self addOns contextActions
]

{ #category : #'api - actions' }
GtCoderModel >> contextMenuActions [
	<return: #Collection of: #GtCoderAction>

	^ self addOns contextMenuActions
]

{ #category : #initialization }
GtCoderModel >> defaultCoderLook [
	^ nil
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

{ #category : #accessing }
GtCoderModel >> gtAttributesFor: aView [
	<gtView>
	attributes ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Attributes';
		priority: 40;
		object: [ self attributes ];
		view: #gtItemsFor:
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

	self coderLook: self defaultCoderLook
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

	^ self addOns mainActions
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

	addOns ifNil: [ ^ self ].
	self addOns requestUpdate.
	self announce: (GtCoderAddOnsUpdateRequest new coder: self)
]

{ #category : #'api - addons' }
GtCoderModel >> shortcuts [
	<return: #Collection of: #BrTextEditorShortcut>

	^ self addOns shortcuts
]

{ #category : #'api - addons' }
GtCoderModel >> shouldAddOnsBeUpdated [
	"Return true if addons should be updated, false otherwise. When a Coder Model is attached to the corresponding Element
	that element should check if addons need to be updated and if it is the case start the update with the help of ${method:GtCoderModel>>#updateAddOnsFrom:}$"
	<return: #Boolean>

	^ self addOns shouldBeUpdated
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
