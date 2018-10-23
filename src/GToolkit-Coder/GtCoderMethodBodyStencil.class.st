Class {
	#name : #GtCoderMethodBodyStencil,
	#superclass : #BrStencil,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI - Stencils'
}

{ #category : #'api - instantiation' }
GtCoderMethodBodyStencil >> create [
	<return: #Object>

	^ GtCoderMethodBodyElement new
		methodCoder: self methodCoder;
		margin: (BlInsets top: 3 right: 0 bottom: 0 left: 5);
		constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal matchParent ]
]

{ #category : #accessing }
GtCoderMethodBodyStencil >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodBodyStencil >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder
]
