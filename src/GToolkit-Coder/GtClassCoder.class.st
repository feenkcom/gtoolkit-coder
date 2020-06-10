Class {
	#name : #GtClassCoder,
	#superclass : #Announcer,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#instVars : [
		'class',
		'object'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtClassCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #elements }
GtClassCoder >> asCardElement [
	| coderElement |
	coderElement := GtClassCardElement new coder: self.
	^ coderElement
]

{ #category : #elements }
GtClassCoder >> asElement [
	| coderElement |
	coderElement := GtBehaviorCoderElement new classCoder: self.
	^ coderElement
]

{ #category : #initialize }
GtClassCoder >> forClass: aClass [
	self
		assert: [ class isNil ]
		description: [ 'Can not change the behavior behind this coder' ].

	class := aClass
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]

{ #category : #'gt-extension' }
GtClassCoder >> gtLiveFor: aView [
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

{ #category : #'system annoucements' }
GtClassCoder >> handleClassDefinitionModified: a [
]

{ #category : #'system annoucements' }
GtClassCoder >> handleClassModified: anAnnouncement [
]

{ #category : #accessing }
GtClassCoder >> icon [
	^ BrGlamorousIcons classicon
]

{ #category : #testing }
GtClassCoder >> isForClass [
	^ true
]

{ #category : #accessing }
GtClassCoder >> name [
	^ self theClass name
]

{ #category : #accessing }
GtClassCoder >> object [
	^ object
]

{ #category : #accessing }
GtClassCoder >> package [
	^ self theClass package
]

{ #category : #accessing }
GtClassCoder >> packageTag [
	^ self package classTagForClass: self theClass
]

{ #category : #actions }
GtClassCoder >> removeClass [
	self theClass removeFromSystem
]

{ #category : #accessing }
GtClassCoder >> theClass [
	^ class
]

{ #category : #'api - navigation' }
GtClassCoder >> withSelectedMethod: aMethod [
	self
		assert: [ class instanceSide = aMethod methodClass instanceSide ]
		description: [ 'Can not select a method from a different class' ].
		
	self
		announce: (GtClassCoderNavigationAnnouncement new method: aMethod)
]
