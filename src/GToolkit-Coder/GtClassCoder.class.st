Class {
	#name : #GtClassCoder,
	#superclass : #Announcer,
	#instVars : [
		'searchFilter',
		'navigationModel',
		'methodsCoder',
		'definitionsCoder',
		'commentsCoder',
		'class'
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
	coderElement := GtClassCoderElement new classCoder: self.
	^ coderElement asScrollableElement
]

{ #category : #accessing }
GtClassCoder >> commentsCoder [
	^ commentsCoder
]

{ #category : #accessing }
GtClassCoder >> definitionsCoder [
	^ definitionsCoder
]

{ #category : #updating }
GtClassCoder >> displayClass: aClass [
	class := aClass.
	methodsCoder := GtClassMethodsCoder forClass: class.
	definitionsCoder := GtClassDefinitionsCoder forClass: class.
	commentsCoder := GtClassCommentsCoder forClass: class.
	self announce: (GtCoderClassSelectedAnnouncement forClass: class)
]

{ #category : #initialize }
GtClassCoder >> forClass: aClass [
	class := aClass.
	methodsCoder := GtClassMethodsCoder forClass: class
	"definitionsCoder := GtClassDefinitionsCoder forClass: class.
	commentsCoder := GtClassCommentsCoder forClass: class."
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	class := anObject class.
	methodsCoder := GtClassMethodsCoder forObject: anObject.
	definitionsCoder := GtClassDefinitionsCoder forClass: class.
	commentsCoder := GtClassCommentsCoder forClass: class
]

{ #category : #accessing }
GtClassCoder >> gtDocumentFor: aView [
	<gtView>
	self theClass ifNil: [ ^ aView empty ].
	^ (self theClass instanceSide gtDocumentFor: aView)
			priority: 1;
			actionButtonIcon: BrGlamorousIcons inspect
				action: [ :aButton | 
					aButton phlow spawnObject: self theClass instanceSide ]
]

{ #category : #ui }
GtClassCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Class';
		priority: 10;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousIcons browse
			action: [ :aButton | self theClass browse ];
		actionButtonIcon: BrGlamorousIcons inspect
			action: [ :aButton | 
				aButton phlow spawnObject: self theClass ]
		
]

{ #category : #accessing }
GtClassCoder >> implementorsFilterString: aString [
	"Set implementors filter"
	self methodsCoder implementorsFilterString: aString
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
		navigationModel classCoder: self ].
	self announce: GtCoderNavigationModelChangedAnnouncement
]

{ #category : #accessing }
GtClassCoder >> searchFilter [
	^ searchFilter
]

{ #category : #accessing }
GtClassCoder >> theClass [
	^ class
]
