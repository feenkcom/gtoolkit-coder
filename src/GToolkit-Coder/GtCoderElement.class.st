Class {
	#name : #GtCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderElement >> buildContent [
	| selectorElement |
	self removeChildren.
	selectorElement := self coderModel searchFilter asElement.
	self addChild: selectorElement.
	self coderModel classCoder ifNotNil: [ :aClassCoder |
		self addChild: aClassCoder asElement ]
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
		do: [ :ann | 
			self updateClassCoderElement ].
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

{ #category : #updating }
GtCoderElement >> updateClassCoderElement [
	| classCoder |
	classCoder := self coderModel classCoder.
	[ self childrenCount > 1 ] whileTrue: [ self removeChildAt: 2 ].
	self addChild: classCoder asElement
]
