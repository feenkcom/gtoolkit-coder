Class {
	#name : #GtCoderMethodActionsElement,
	#superclass : #BlElement,
	#instVars : [
		'mainToolbar',
		'contextToolbar',
		'separator',
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodActionsElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	mainToolbar := self newToolbar.
	
	separator := BlElement new
		background: (Color gray alpha: 0.2);
		margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5);
		constraintsDo: [ :c |
			c horizontal exact: 1.
			c vertical matchParent ].

	contextToolbar := self newToolbar.

	self addChildren: { mainToolbar . separator . contextToolbar }
]

{ #category : #accessing }
GtCoderMethodActionsElement >> methodCoder [
	<return: #GtMethodCoder>

	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodActionsElement >> methodCoder: aGtMethodCoder [
	methodCoder := aGtMethodCoder.
	
	mainToolbar addItems: (aGtMethodCoder mainActions
		collect: [ :aGtCoderAction | self newButtonForAction: aGtCoderAction ]).

	contextToolbar addItems: (aGtMethodCoder contextActions
		collect: [ :aGtCoderAction | self newButtonForAction: aGtCoderAction ]).
		
	separator visibility: (contextToolbar hasItems
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ])
]

{ #category : #'instance creation' }
GtCoderMethodActionsElement >> newButtonForAction: aGtCoderAction [
	<return: #BrButton>
	
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		label: aGtCoderAction title;
		icon: aGtCoderAction icon asElement;
		action: aGtCoderAction
]

{ #category : #'instance creation' }
GtCoderMethodActionsElement >> newToolbar [
	<return: #BrToolbar>

	^ BrToolbar new
		look: BrToolbarLook new;
		layout: (BlGridLayout horizontal rowCount: 1; cellSpacing: 3);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ]
]
