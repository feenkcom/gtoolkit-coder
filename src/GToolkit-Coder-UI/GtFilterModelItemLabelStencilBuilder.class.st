Class {
	#name : #GtFilterModelItemLabelStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #'api - instantiation' }
GtFilterModelItemLabelStencilBuilder >> buildDefault [
	^ object gtDisplayString
]

{ #category : #accessing }
GtFilterModelItemLabelStencilBuilder >> object [
	^ object
]

{ #category : #accessing }
GtFilterModelItemLabelStencilBuilder >> object: anObject [
	object := anObject
]

{ #category : #'api - instantiation' }
GtFilterModelItemLabelStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.

	aStencilExecutor push: object
]

{ #category : #initialization }
GtFilterModelItemLabelStencilBuilder >> reset [
	object := nil
]
