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
	methodsCoder := GtClassMethodsCoder forClass: class.
	definitionsCoder := GtClassDefinitionsCoder forClass: class.
	commentsCoder := GtClassCommentsCoder forClass: class
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	class := anObject class.
	methodsCoder := GtClassMethodsCoder forObject: anObject.
	definitionsCoder := GtClassDefinitionsCoder forClass: class.
	commentsCoder := GtClassCommentsCoder forClass: class
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

{ #category : #ui }
GtClassCoder >> gtSpotterFor: anAction [
	<gtAction>
	^ anAction explicit
		priority: -1;
		stencil: [ | dropdown |
			dropdown := BrDropdown new.
			dropdown
				look:
					(BrGlamorousDropdownLook new
						outskirtsEmbellisher: [ :e | 
							e
								background: BrGlamorousColors lightBorderColor;
								yourself ];
						yourself);
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ];
				toggle: [ BrButton new
						look: BrGlamorousButtonWithIconLook;
						icon: BrGlamorousIcons search asElement;
						when: BlElementBackgroundChangedEvent
							do: [ :e | 
							(dropdown isExpanded
								and: [ e target background paint color
										~= BrGlamorousColors lightBorderColor ])
								ifTrue: [ e target background: BrGlamorousColors lightBorderColor ] ];
						yourself ];
				popup: [ | model |
					model := GtSpotter new.
					model announcer
						when: GtSpotterActOn
						do: [ :e | 
							| item |
							item := e element.
							[ (item isKindOf: GtSpotterCandidate)
								and: [ item item ~~ item ] ] whileTrue: [ item := item item ].
							((#(singleClick doubleClick keyPressed) includes: e eventType)
								and: [ item isKindOf: Behavior ])
								ifTrue: [ dropdown collapse.
									self displayClass: item ] ].
					GtSpotterElement new
						spotterModel: model;
						constraintsDo: [ :c | 
							c horizontal exact: 600.
							c vertical exact: 400 ];
						margin: (BlInsets all: 1);
						geometry: (BlRectangle cornerRadius: 4);
						in: [ :e | 
							self
								flag: 'FIXME need to remove original listener to avoid phlow inspect'.
							model announcer weak gtSubscriptions subscriptions
								detect: [ :g | 
									g announcementClass == GtSpotterSelectedCandidateChanged
										and: [ g action isMessageSend
												and: [ g action selector = #onCandidateSelected:
														and: [ g action receiver == e ] ] ] ]
								ifFound: [ :g | g announcer subscriptions remove: g ] ];
						yourself ];
				yourself ]
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
