Class {
	#name : #GtCoderMethodElement,
	#superclass : #BrExpander,
	#traits : 'TBlDrawingCache',
	#classTraits : 'TBlDrawingCache classTrait',
	#instVars : [
		'methodCoder',
		'collapsedElement',
		'contentElement',
		'damageReported',
		'session'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #converting }
GtCoderMethodElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #accessing }
GtCoderMethodElement >> collapsedElementDo: aBlock [
	collapsedElement ifNotNil: aBlock
]

{ #category : #accessing }
GtCoderMethodElement >> contentElementDo: aBlock [
	contentElement ifNotNil: aBlock
]

{ #category : #accessing }
GtCoderMethodElement >> gtAllShortcutsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList 
		title: 'All shortcuts' translated;
		priority: 10;
		items: [ self shortcuts, self methodCoder addOns shortcuts ];
		column: 'Key' do: [:aColumn | 
			aColumn item: [ :each | each combination gtDisplayString ]; matchParent ];
		column: 'Action' do: [:aColumn |
			aColumn item: [ :each | each action asString ]; matchParent ]
]

{ #category : #initialization }
GtCoderMethodElement >> initialize [
	super initialize.
	self
		vFitContent;
		hMatchParent;
		margin: (BlInsets all: 4).

	self header: [ collapsedElement := self newCollapsedElement ].
	self content: [ contentElement := self newContentElement ].

	self look:
			(GtCoderExpanderLook new
				borderWidth: 0;
				padding: (BlInsets top: 1 left: 10 bottom: 1 right: 10))
			+
			(BrInteractiveLook new
				style: [ :aStyler |
					aStyler default: [ self background: Color transparent ].
					aStyler expanded: [ self background: Color white ] ]).
	
	self addShortcut: (BlShortcut new
		combination: BlKeyCombination primaryReturn;
		action: [ self toggle ]).

	expandableModel
		when: BrExpansionChanged
		do: [ :event | self methodCoderDo: [ :aCoder | aCoder expanded: self isExpanded ] ].
]

{ #category : #testing }
GtCoderMethodElement >> isExpanded [
	^ expandableModel isExpanded
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder [
	<return: #GtMethodCoder>

	self
		assert: [ methodCoder isNotNil ]
		description: [ 'Coder is not set!' ].

	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoder: aGtMethodCoder [
	self
		assert: [ aGtMethodCoder isNotNil ]
		description: [ 'Coder must not be nil' ].

	methodCoder := aGtMethodCoder.

	self collapsedElementDo: [ :aCollapsedElement | self setCollapsedElement: aCollapsedElement coder: aGtMethodCoder ].
	self contentElementDo: [ :aContentElement | self setContentElement: aContentElement coder: aGtMethodCoder ].

	methodCoder expanded
		ifTrue: [ self expand ]
]

{ #category : #accessing }
GtCoderMethodElement >> methodCoderDo: aBlock [
	methodCoder ifNotNil: aBlock
]

{ #category : #private }
GtCoderMethodElement >> newCollapsedElement [
	| aCollapsedElement |

	aCollapsedElement := GtCoderMethodPatternElement new.
	aCollapsedElement constraintsDo: [ :c | 
		c vertical fitContent.
		c horizontal matchParent.
		c margin: (BlInsets left: 5) ].
	
	self methodCoderDo: [ :aMethodCoder | self setCollapsedElement: aCollapsedElement coder: aMethodCoder ].

	^ aCollapsedElement
]

{ #category : #private }
GtCoderMethodElement >> newContentElement [
	| aContentElement |

	aContentElement := GtCoderMethodBodyElement new.
	aContentElement
		constraintsDo: [ :c | 
			c margin: (BlInsets left: 5).
			c vertical fitContent.
			c horizontal matchParent ].

	self methodCoderDo: [ :aMethodCoder | self setContentElement: aContentElement coder: aMethodCoder ].

	^ aContentElement
]

{ #category : #private }
GtCoderMethodElement >> setCollapsedElement: aCollapsedElement coder: aMethodCoder [
	"Configure a collapsed element with a new given coder"

	aCollapsedElement methodCoder: aMethodCoder.	
	aMethodCoder methodsCoder
		ifNotNil: [ :coder | coder methodCoderLook ifNotNil: [ :look | aCollapsedElement look: look ] ].
]

{ #category : #private }
GtCoderMethodElement >> setContentElement: aCollapsedElement coder: aMethodCoder [
	"Configure a content element with a new given coder"
	| aLook |

	aCollapsedElement methodCoder: aMethodCoder.
	aLook := methodCoder coderLook.

	methodCoder methodsCoder
		ifNotNil: [ :coder | 
			coder methodCoderLook
				ifNotNil: [ :methodsLook | 
					aLook := aLook notNil
						ifTrue: [ aLook + methodsLook ]
						ifFalse: [ methodsLook ] ] ].
	aLook notNil
		ifTrue: [ aCollapsedElement look: aLook ]
]
