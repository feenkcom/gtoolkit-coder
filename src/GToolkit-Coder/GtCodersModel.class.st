Class {
	#name : #GtCodersModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'coders',
		'items'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'initialize-release' }
GtCodersModel class >> forItems: aCollection [
	^ self new
		forItems: aCollection;
		yourself
]

{ #category : #announcer }
GtCodersModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #elements }
GtCodersModel >> asElement [
	^ self elementClass new
		coders: self;
		yourself
]

{ #category : #elements }
GtCodersModel >> coderLook [
	^ nil
]

{ #category : #accessing }
GtCodersModel >> coders [
	^ coders
]

{ #category : #elements }
GtCodersModel >> elementClass [
	self subclassResponsibility
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

{ #category : #updating }
GtCodersModel >> updateCoders [
	coders := items collect: [ :each | self newCoderFor: each ].
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]

{ #category : #'api - navigation' }
GtCodersModel >> updateNavigation: aGtCoderNavigationPackagesTagsClassesModel [
]
