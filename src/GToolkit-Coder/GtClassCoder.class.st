Class {
	#name : #GtClassCoder,
	#superclass : #Announcer,
	#instVars : [
		'searchFilter',
		'navigationModel',
		'methodsCoder'
	],
	#category : #'GToolkit-Coder'
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
GtClassCoder >> asElement [
	| coderElement |
	coderElement := GtClassCoderElement new coderModel: self.
	^ coderElement asScrollableElement
]

{ #category : #updating }
GtClassCoder >> displayClass: aClass [
	methodsCoder := GtClassMethodsCoder forClass: aClass.
	self announce: (GtCoderClassSelectedAnnouncement forClass: aClass)
]

{ #category : #initialize }
GtClassCoder >> forClass: aBehavior [
	methodsCoder := GtClassMethodsCoder forClass: aBehavior
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	methodsCoder := GtClassMethodsCoder forObject: anObject
]

{ #category : #ui }
GtClassCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousIcons browse
			action: [ :aButton | self theClass browse ];
		actionButtonIcon: BrGlamorousIcons inspect
			action: [ :aButton | 
				aButton phlow spawnObject: self theClass ]
		
]

{ #category : #initialize }
GtClassCoder >> initialize [
	super initialize.
	searchFilter := GtCoderClassSelector new
		coder: self.
]

{ #category : #accessing }
GtClassCoder >> methodsCoder [ 
	^ methodsCoder
]

{ #category : #accessing }
GtClassCoder >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtClassCoder >> navigationModel: aNavigationModel [
	navigationModel := aNavigationModel.
	navigationModel ifNotNil: [ 
		navigationModel coderModel: self ].
	self announce: GtCoderNavigationModelChangedAnnouncement
]

{ #category : #accessing }
GtClassCoder >> searchFilter [
	^ searchFilter
]

{ #category : #accessing }
GtClassCoder >> theClass [
	^ methodsCoder 
		ifNil: [ nil ] 
		ifNotNil: [ :aMethodsCoder | aMethodsCoder classOrMetaClass ]
]
