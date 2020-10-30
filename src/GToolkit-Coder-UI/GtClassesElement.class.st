Class {
	#name : #GtClassesElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'building ui' }
GtClassesElement >> buildContainer [
	| aClassList |
	self removeChildren.

	aClassList := BrSimpleList new
		itemStencil: [ GtClassCardElement new ];
		itemDataBinder: [ :eachClassCard :eachClassCoder | eachClassCard coder: eachClassCoder ];
		items: (coder coders asSortedCollection: [ :a :b | a theClass name < b theClass name ]).

	self addChild: aClassList
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
