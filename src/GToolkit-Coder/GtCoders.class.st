Class {
	#name : #GtCoders,
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
GtCoders class >> forItems: aCollection [
	^ self new
		forItems: aCollection;
		yourself
]

{ #category : #announcer }
GtCoders >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #elements }
GtCoders >> asElement [
	^ self elementClass new
		coders: self;
		yourself
]

{ #category : #accessing }
GtCoders >> coders [
	^ coders
]

{ #category : #elements }
GtCoders >> elementClass [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
GtCoders >> forItems: aCollection [
	items := aCollection.
	coders := items collect: [ :each | self newCoderFor: each ]
]

{ #category : #ui }
GtCoders >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #'initialize-release' }
GtCoders >> initialize [
	super initialize.
	coders := #().
	items := #()
]

{ #category : #private }
GtCoders >> newCoderFor: anObject [
	self subclassResponsibility
]
