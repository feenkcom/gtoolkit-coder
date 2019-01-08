Class {
	#name : #GtMethodsCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'methodsCoder',
		'listElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #ui }
GtMethodsCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self methodsListElement as: #methodsList.
	methodsCoder look ifNotNil: [ :look | self look: look ]
]

{ #category : #ui }
GtMethodsCoderElement >> buildElementForCoder: aMethodCoder [
	^ aMethodCoder asElement
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
	listElement stencil: [ :each | self buildElementForCoder: each ].
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
