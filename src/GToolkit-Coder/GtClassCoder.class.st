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
GtClassCoder >> forClass: aClass [
	class := aClass.
	methodsCoder forClass: class.
	definitionsCoder forClass: class.
	commentsCoder forClass: class.
	self announce: (GtCoderClassSelectedAnnouncement forClass: class)
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	self forClass: anObject class
]

{ #category : #ui }
GtClassCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Class';
		priority: 1;
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
		coder: self;
		yourself.
	navigationModel := GtClassCoderPackagesTreeNavigation new
		classCoder: self;
		yourself.
	methodsCoder := GtClassMethodsCoder new.
	definitionsCoder := GtClassDefinitionsCoder new.
	commentsCoder := GtClassCommentsCoder new
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
	navigationModel classCoder: self.
	self announce: GtCoderNavigationModelChangedAnnouncement
]

{ #category : #opening }
GtClassCoder >> openInInspector [
	| anInspector aSpace |
	anInspector := GtInspector new.
	anInspector
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	anInspector addPageWithContent: self asElement for: self.
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: 'Class Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anInspector.
	aSpace show
]

{ #category : #accessing }
GtClassCoder >> searchFilter [
	^ searchFilter
]

{ #category : #accessing }
GtClassCoder >> theClass [
	^ class
]
