Class {
	#name : #GtCoderCardElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtCoderCardElement >> buildContainer [
	self removeChildren.
	self addChild: (BlShrinkingTextElement new
			 text: coder name asRopedText glamorousRegularFont bold;
			 constraintsDo: [ :c | 
				 c vertical fitContent.
				 c horizontal matchParent ]).
	self detailsLabel ifNotEmpty: [ :label | 
		self addChild: (BlShrinkingTextElement new
				 text: (label asRopedText glamorousRegularFont thin foreground:
							  BrGlamorousColors defaultButtonTextColor);
				 constraintsDo: [ :c | 
					 c vertical fitContent.
					 c horizontal matchParent ]) ]
]

{ #category : #accessing }
GtCoderCardElement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderCardElement >> coder: anObject [
	coder := anObject.
	self buildContainer
]

{ #category : #'building ui' }
GtCoderCardElement >> detailsLabel [
	^ ''
]

{ #category : #initialization }
GtCoderCardElement >> initialize [
	super initialize.
	self viewModel: (BrInteractiveModel new addStates: { 
				 BrEnablementModel new.
				 BrPressModel new.
				 BrHoverModel new }).
	self look:
		(BrGlamorousButtonExteriorLook new borderPaint: Color transparent).
	self layout: (BlLinearLayout vertical cellSpacing: 2).
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	self margin: (BlInsets
			 top: 5
			 left: 10
			 bottom: 5
			 right: 10).
	self padding: (BlInsets all: 5).
	self when: BlClickEvent do: [ :event | self selectCoder ]
]

{ #category : #private }
GtCoderCardElement >> selectCoder [
	self
		allParentsDetect: [ :each | each isKindOf: GtPackagesCoderElement ]
		ifFound: [ :element | element updateSelection: coder ]
		ifNone: [ self phlow spawnObject: coder ]
]
