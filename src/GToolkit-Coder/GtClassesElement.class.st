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
	element := BrSimpleList new.
	element
		stencil: [ :each | 
			each asCardElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself ].
	element
		items:
			(coder coders
				asSortedCollection: [ :a :b | a theClass name < b theClass name ]).
	self addChild: element
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
