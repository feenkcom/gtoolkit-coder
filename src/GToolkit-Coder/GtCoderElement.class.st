Class {
	#name : #GtCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coder',
		'innerContainer'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderElement >> buildContent [
	| selectorElement |
	selectorElement := self coderModel searchFilter asElement.
	self addChild: selectorElement.
	
	innerContainer := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: innerContainer.
	
	self buildNavigation.
	self coderModel classCoder ifNotNil: [ :aClassCoder |
		| classCoderElement | 
		
		classCoderElement := aClassCoder asElement.
		classCoderElement constraintsDo: [ :c |
			c linear weight: 2 ].
		innerContainer addChild: classCoderElement ]
]

{ #category : #accessing }
GtCoderElement >> buildNavigation [
	| navigationModel navigationElement |
	navigationModel := self coderModel navigationModel.
	navigationModel ifNil: [ ^ self ].
	
	self coderModel navigationModel displayPosition = #top
		ifTrue: [ innerContainer layout: BlLinearLayout vertical ].
	self coderModel navigationModel displayPosition = #left
		ifTrue: [ innerContainer layout: BlLinearLayout horizontal ].
	
	navigationElement := self coderModel navigationModel asElement.
	navigationElement padding: (BlInsets all: 10).
	navigationElement constraintsDo: [ :c |
		c linear weight: 1 ].
	innerContainer addChild: navigationElement.
]

{ #category : #accessing }
GtCoderElement >> coderModel [
	^ coder
]

{ #category : #accessing }
GtCoderElement >> coderModel: aCoder [
	coder := aCoder.
	coder
		when: GtCoderClassSelectedAnnouncement
		do: [ :ann | self updateClassCoderElement ].
	self buildContent.
]

{ #category : #initialization }
GtCoderElement >> initialize [ 
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #accessing }
GtCoderElement >> innerContainer [
	^ innerContainer
]

{ #category : #updating }
GtCoderElement >> updateClassCoderElement [
	| classCoder |
	classCoder := self coderModel classCoder.
	[ self innerContainer childrenCount > 1 ] whileTrue: [ self innerContainer removeChildAt: 2 ].
	self innerContainer addChild: classCoder asElement
]
