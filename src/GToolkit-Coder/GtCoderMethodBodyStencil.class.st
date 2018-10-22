Class {
	#name : #GtCoderMethodBodyStencil,
	#superclass : #BrStencil,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'api - instantiation' }
GtCoderMethodBodyStencil >> create [
	<return: #Object>

	^ GtMethodBodyElement new
		methodCoder: self methodCoder;
		layout: BlLinearLayout vertical;
		margin: (BlInsets top: 3);
		constraintsDo: [ :c |
			c vertical fitContent.
			c horizontal matchParent ]
]

{ #category : #accessing }
GtCoderMethodBodyStencil >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodBodyStencil >> methodCoder: anObject [
	methodCoder := anObject
]
