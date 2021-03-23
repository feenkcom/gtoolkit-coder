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
		'monitor',
		'announcer',
		'id',
		'suppressedAnnouncements',
		'attributes',
		'extraAddOns'
	],
	#classVars : [
		'UniqueIdGenerator'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderModel class >> gtAstCoderAddOnsFor: aView context: aPhlowContext [
	<gtClassView>
	^ aView explicit
		title: 'Coder AddOns';
		priority: 60;
		stencil: [ 
			#gtAstCoderAddOns: gtPragmas
				& (GtSearchMethodsInClassFilter new 
					forClass: self;
					includeSuperclass: true) ]
]

{ #category : #'class initialization' }
GtCoderModel class >> initialize [
	UniqueIdGenerator := BlUniqueIdGenerator new
]

{ #category : #'api - addons' }
GtCoderModel >> addOns [
	^ extraAddOns ifNil: [ extraAddOns := self newAddOns ]
]

{ #category : #'api - addons' }
GtCoderModel >> addOnsClass [
	^ GtCoderAddOns
]

{ #category : #'api - announcer' }
GtCoderModel >> announcer [
	<return: #Announcer>

	^ announcer
]

{ #category : #'api - converting' }
GtCoderModel >> asNewCoderModelWithSameSubject [
	"Return new coder model with same subject (e.g., package, class, method)"
	<return: #GtCoderModel>
	^ self subclassResponsibility
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

{ #category : #'mutual exclusion' }
GtCoderModel >> critical: aBlock [
	^ monitor critical: aBlock
]

{ #category : #accessing }
GtCoderModel >> expanded [
	self deprecated: 'The expansion state was moved to the ViewModel'
]

{ #category : #accessing }
GtCoderModel >> expanded: aBoolean [
	self deprecated: 'The expansion state was moved to the ViewModel'
]

{ #category : #accessing }
GtCoderModel >> id [
	^ id
]

{ #category : #initialization }
GtCoderModel >> initialize [
	super initialize.

	id := UniqueIdGenerator generateUniqueId.
	monitor := Monitor new.
	announcer := GtCoderAnnouncer new.

	self coderLook: self defaultCoderLook
]

{ #category : #initialization }
GtCoderModel >> initializeAddOns: addOns [
]

{ #category : #initialization }
GtCoderModel >> initializeShortcuts: addOns [
]

{ #category : #'api - actions' }
GtCoderModel >> mainActions [
	"Return a collection of main actions in the coder, for example save"
	<return: #Collection of: #GtCoderAction>

	^ self addOns mainActions
]

{ #category : #'api - addons' }
GtCoderModel >> newAddOns [
	^ self addOnsClass new
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

	"addOns
		ifNil: [ ^ self ].
	self addOns requestUpdate.
	self announce: (GtCoderAddOnsUpdateRequest new coder: self)"
]

{ #category : #subscriptions }
GtCoderModel >> subscribeToSystem [
	"do nothing"
]

{ #category : #subscriptions }
GtCoderModel >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
