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
GtClassCoder >> asCardElement [
	| coderElement |
	coderElement := GtClassCardElement new coder: self.
	^ coderElement
]

{ #category : #elements }
GtClassCoder >> asElement [
	| coderElement |
	coderElement := GtClassCoderElement new classCoder: self.
	^ coderElement
]

{ #category : #accessing }
GtClassCoder >> commentsCoder [
	^ commentsCoder
		ifNil: [ commentsCoder := GtClassCommentsCoder new.
			class notNil
				ifTrue: [ commentsCoder forClass: class ].
			commentsCoder ]
]

{ #category : #accessing }
GtClassCoder >> definitionsCoder [
	^ definitionsCoder
		ifNil: [ definitionsCoder := GtClassDefinitionsCoder new.
			class notNil
				ifTrue: [ definitionsCoder forClass: class ].
			definitionsCoder ]
]

{ #category : #updating }
GtClassCoder >> forClass: aClass [
	class := aClass.
	methodsCoder notNil
		ifTrue: [ methodsCoder forClass: class ].
	definitionsCoder notNil
		ifTrue: [ definitionsCoder forClass: class ].
	commentsCoder notNil
		ifTrue: [ commentsCoder forClass: class ].
	self announce: (GtCoderClassUpdatedAnnouncement forClass: class)
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	class := anObject class.
	anObject notNil
		ifTrue: [ self methodsCoder forObject: anObject ].
	definitionsCoder notNil
		ifTrue: [ definitionsCoder forClass: class ].
	commentsCoder notNil
		ifTrue: [ commentsCoder forClass: class ].
	self announce: (GtCoderClassUpdatedAnnouncement forClass: class)
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
GtClassCoder >> icon [
	^ BrGlamorousIcons classicon asElement
]

{ #category : #accessing }
GtClassCoder >> implementorsFilterString: aString [
	"Set implementors filter"
	self methodsCoder implementorsFilterString: aString
]

{ #category : #initialize }
GtClassCoder >> initialize [
	super initialize.
	navigationModel := GtClassCoderPackagesAndHierarchyNavigation new
		classCoder: self;
		yourself
]

{ #category : #accessing }
GtClassCoder >> methodsCoder [
	^ methodsCoder
		ifNil: [ methodsCoder := GtClassMethodsCoder new.
			class notNil
				ifTrue: [ methodsCoder forClass: class ].
			methodsCoder ]
]

{ #category : #accessing }
GtClassCoder >> name [
	^ self theClass name
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
GtClassCoder >> packageTreeCoders [
	^ #()
]

{ #category : #accessing }
GtClassCoder >> searchFilter [
	^ searchFilter
		ifNil: [ searchFilter := GtCoderClassSelector new
				coder: self;
				yourself ]
]

{ #category : #accessing }
GtClassCoder >> theClass [
	^ class
]

{ #category : #updating }
GtClassCoder >> updateForPackage: aPackage [
	class := nil.
	self announce: (GtCoderPackageUpdatedAnnouncement new package: aPackage)
]

{ #category : #scripting }
GtClassCoder >> withClass: aClass [
	self forClass: aClass
]

{ #category : #scripting }
GtClassCoder >> withHierarchy [
	self
		announce: (GtClassCoderNavigationAnnouncement new navigationTab: #hierarchy)
]

{ #category : #scripting }
GtClassCoder >> withPackages [
	self
		announce: (GtClassCoderNavigationAnnouncement new navigationTab: #packages)
]

{ #category : #scripting }
GtClassCoder >> withSelectedMethod: aMethod [
	self forClass: aMethod methodClass.
	(self methodsCoder coders
		detect: [ :each | each compiledMethod == aMethod ]
		ifNone: [  ])
		ifNotNil: [ :coder | self methodsCoder selectAndScrollTo: coder ]
]
