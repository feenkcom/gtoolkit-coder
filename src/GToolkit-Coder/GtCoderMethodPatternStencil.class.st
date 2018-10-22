Class {
	#name : #GtCoderMethodPatternStencil,
	#superclass : #BrStencil,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI - Stencils'
}

{ #category : #'api - instantiation' }
GtCoderMethodPatternStencil >> create [
	<return: #Object>

	^ GtCoderMethodPatternElement new
		methodCoder: self methodCoder;
		margin: (BlInsets left: 5);
		constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal matchParent ]
]

{ #category : #accessing }
GtCoderMethodPatternStencil >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodPatternStencil >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder
]
