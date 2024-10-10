Class {
	#name : #GtFilterModelItemIconStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #'api - instantiation' }
GtFilterModelItemIconStencilBuilder >> buildDefault [
	^ BlElement new
		size: 8 @ 8;
		background: BlBackground transparent
]

{ #category : #accessing }
GtFilterModelItemIconStencilBuilder >> object [
	^ object
]

{ #category : #accessing }
GtFilterModelItemIconStencilBuilder >> object: anObject [
	object := anObject
]

{ #category : #'api - instantiation' }
GtFilterModelItemIconStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.

	aStencilExecutor push: object
]

{ #category : #initialization }
GtFilterModelItemIconStencilBuilder >> reset [
	object := nil
]
