Class {
	#name : #GtClassesElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtClassesElement >> buildContainer [
	| element |
	self removeChildren.
	element := BlElement new.
	element layout: BlFlowLayout new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element padding: (BlInsets all: 0).
	element
		addChildren:
			((coder coders
				asSortedCollection: [ :a :b | a theClass name < b theClass name ])
				collect: [ :each | 
					BlLazyElement new
						elementBuilder: [ each asCardElement ];
						margin: (BlInsets all: 10);
						background: Color white;
						look:
							BrShadowLook + BrGlamorousWithVerticalResizerLook
								+ BrGlamorousWithHorizontalResizerLook;
						width: 200;
						height: 150 ]).
	self addChild: element asScrollableElement
]

{ #category : #accessing }
GtClassesElement >> coders: aCoder [
	coder := aCoder.
	self buildContainer
]

{ #category : #initialization }
GtClassesElement >> initialize [
	super initialize.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self padding: (BlInsets all: 0)
]
