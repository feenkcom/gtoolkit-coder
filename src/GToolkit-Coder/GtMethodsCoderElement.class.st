Class {
	#name : #GtMethodsCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'methodsCoder',
		'listElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #converting }
GtMethodsCoderElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #ui }
GtMethodsCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self methodsInfiniteListElement as: #methodsList.
]

{ #category : #ui }
GtMethodsCoderElement >> buildElementForCoder: aMethodCoder [
	^ aMethodCoder asElement
]

{ #category : #accessing }
GtMethodsCoderElement >> listElement [
	^ listElement
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
GtMethodsCoderElement >> methodsInfiniteListElement [
	| dataSource |
	dataSource := GtMethodsCoderDataSource new
		methodsCoder: methodsCoder.
	listElement := GtMethodsCoderInfiniteElement new
		dataSource: dataSource;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ listElement
]

{ #category : #private }
GtMethodsCoderElement >> updateList [
	listElement dataSource updateCoders
]
