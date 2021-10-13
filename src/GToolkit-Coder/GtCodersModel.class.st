Class {
	#name : #GtCodersModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtOptions',
	#classTraits : 'TGtAnnouncer classTrait + TGtOptions classTrait',
	#instVars : [
		'announcer',
		'items',
		'coders'
	],
	#category : 'GToolkit-Coder-Coders'
}

{ #category : #'initialize-release' }
GtCodersModel class >> forItems: aCollection [
	^ self new
		forItems: aCollection;
		yourself
]

{ #category : #'private - adding / removing' }
GtCodersModel >> addCoder: aCoder [
	coders add: aCoder.
	self subscribeToCoder: aCoder.
	self notifyCoderAdded: aCoder.
]

{ #category : #'private - adding / removing' }
GtCodersModel >> addFirstCoder: aCoder [
	coders addFirst: aCoder.
	self subscribeToCoder: aCoder.
	self notifyCoderAdded: aCoder
]

{ #category : #announcer }
GtCodersModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #testing }
GtCodersModel >> canFilter [
	^ false
]

{ #category : #accessing }
GtCodersModel >> coders [
	^ coders
]

{ #category : #'initialize-release' }
GtCodersModel >> forItems: aCollection [
	items := aCollection.
	coders := items collect: [ :each | self newCoderFor: each ]
]

{ #category : #ui }
GtCodersModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'initialize-release' }
GtCodersModel >> initialize [
	super initialize.
	coders := #().
	items := #()
]

{ #category : #private }
GtCodersModel >> newCoderFor: anObject [
	self subclassResponsibility
]

{ #category : #'private - notifying' }
GtCodersModel >> notifyCoderAdded: aCoder [
	self announce: (GtCodersCoderAdded new
		coders: self;
		coder: aCoder)
]

{ #category : #'private - notifying' }
GtCodersModel >> notifyCoderRemoved: aCoder [
	self announce: (GtCodersCoderRemoved new
		coders: self;
		coder: aCoder)
]

{ #category : #'private - adding / removing' }
GtCodersModel >> removeCoder: aCoder [
	self unsubscribeFromCoder: aCoder.
	coders remove: aCoder ifAbsent: [ ^ self ].
	self notifyCoderRemoved: aCoder
]

{ #category : #'private - subscriptions' }
GtCodersModel >> subscribeToCoder: eachCoder [
]

{ #category : #'private - subscriptions' }
GtCodersModel >> subscribeToSystem [
	"do nothing"
]

{ #category : #'private - subscriptions' }
GtCodersModel >> unsubscribeFromCoder: aCoder [
	aCoder unsubscribe: self
]

{ #category : #'private - subscriptions' }
GtCodersModel >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #updating }
GtCodersModel >> updateCoders [
	coders := items collect: [ :each | self newCoderFor: each ].
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]
