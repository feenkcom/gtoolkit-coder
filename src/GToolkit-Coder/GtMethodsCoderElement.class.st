Class {
	#name : #GtMethodsCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'methodsCoder',
		'listElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #private }
GtMethodsCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	methodsCoder look ifNotNil: [ :look | self look: look ].
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self methodsListElement
]

{ #category : #accessing }
GtMethodsCoderElement >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtMethodsCoderElement >> methodsCoder: aMethodsCoder [
	methodsCoder := aMethodsCoder.
	self buildElement.
	methodsCoder announcer weak
		when: GtMethodCoderAdded , GtMethodCoderRemoved , GtCoderMethodsListChanged
		send: #updateList
		to: self
]

{ #category : #ui }
GtMethodsCoderElement >> methodsListElement [
	listElement := BrSimpleList new.
	listElement stencil: [ :each | each asElement ].
	listElement padding: (BlInsets all: 10).
	listElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	listElement display: methodsCoder coders.
	^ listElement
]

{ #category : #private }
GtMethodsCoderElement >> updateList [
	listElement display: methodsCoder coders
]
