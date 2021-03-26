Class {
	#name : #GtBehaviorCoder,
	#superclass : #GtCoderModel,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#instVars : [
		'class',
		'object',
		'hasObject',
		'definitionCoder',
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #constants }
GtBehaviorCoder class >> addNewMethodButtonName [
	^ #'button--add-new-method'
]

{ #category : #constants }
GtBehaviorCoder class >> behaviorNameEditorName [
	^ #'behavior-coder--behavior-name-editor'
]

{ #category : #'instance creation' }
GtBehaviorCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtBehaviorCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #'api - converting' }
GtBehaviorCoder >> asNewCoderModelWithSameSubject [
	"Return new coder model with same subject (e.g., package, class, method)"
	<return: #GtCoderModel>
	^ self hasObject 
		ifTrue: [ self class forObject: self object ] 
		ifFalse: [ self class forClass: self behavior ]
]

{ #category : #accessing }
GtBehaviorCoder >> behavior [
	<return: #Behavior>

	^ class
]

{ #category : #accessing }
GtBehaviorCoder >> definitionCoder [
	<return: #GtBehaviorDefinitionCoder>

	^ definitionCoder
]

{ #category : #initialize }
GtBehaviorCoder >> forClass: aClass [
	hasObject := false.
	self initializeClass: aClass.

	self methodsCoder: (GtClassMethodsCoder forClass: aClass)
]

{ #category : #initialize }
GtBehaviorCoder >> forObject: anObject [
	object := anObject.
	hasObject := true.
	self initializeClass: anObject class.
	
	self methodsCoder: (GtClassMethodsCoder forObject: object)
]

{ #category : #'gt-extension' }
GtBehaviorCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Class';
		priority: 1;
		stencil: self;
		actionButtonIcon: BrGlamorousVectorIcons browse
			action: [ :aButton | self theClass browse ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			action: [ :aButton | aButton phlow spawnObject: self theClass ]
]

{ #category : #testing }
GtBehaviorCoder >> hasObject [
	<return: #Boolean>

	^ hasObject
]

{ #category : #accessing }
GtBehaviorCoder >> icon [
	^ BrGlamorousIcons classicon
]

{ #category : #initialize }
GtBehaviorCoder >> initialize [
	super initialize.

	hasObject := false
]

{ #category : #initialize }
GtBehaviorCoder >> initializeClass: aClass [
	self
		assert: [ class isNil ]
		description: [ 'Can not change the behavior behind this coder' ].

	class := aClass.
	definitionCoder := GtBehaviorDefinitionCoder forBehavior: class
]

{ #category : #testing }
GtBehaviorCoder >> isForClass [
	^ true
]

{ #category : #accessing }
GtBehaviorCoder >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtBehaviorCoder >> methodsCoder: aMethodsCoder [
	methodsCoder ifNotNil: [ :aCoder | aCoder announcer unsubscribe: self ].
	methodsCoder := aMethodsCoder.
	aMethodsCoder weak
		when: GtCodersFiltersChanged
		send: #onMethodsCoderFiltersChanged:
		to: self
]

{ #category : #accessing }
GtBehaviorCoder >> name [
	^ self theClass name
]

{ #category : #accessing }
GtBehaviorCoder >> object [
	<return: #Object>

	^ object
]

{ #category : #'private - announcement handling' }
GtBehaviorCoder >> onMethodsCoderFiltersChanged: aGtCodersFiltersChanged [
	self announcer announce: aGtCodersFiltersChanged.
]

{ #category : #accessing }
GtBehaviorCoder >> package [
	^ self theClass package
]

{ #category : #accessing }
GtBehaviorCoder >> packageTag [
	^ self package classTagForClass: self theClass
]

{ #category : #actions }
GtBehaviorCoder >> removeClass [
	self theClass removeFromSystem
]

{ #category : #accessing }
GtBehaviorCoder >> theClass [
	<return: #Class>

	^ class
]

{ #category : #'api - navigation' }
GtBehaviorCoder >> withMethodProtocol: aMethodProtocol source: aSource [

	self announce: (GtClassCoderMethodProtocolNavigationAnnouncement new 
		source: aSource;
		methodProtocol: aMethodProtocol)
]

{ #category : #'api - navigation' }
GtBehaviorCoder >> withSelectedMethod: aMethod [
	self
		assert: [ class instanceSide = aMethod methodClass instanceSide ]
		description: [ 'Can not select a method from a different class' ].

	self announce: (GtClassCoderMethodNavigationAnnouncement new method: aMethod)
]
