Class {
	#name : #GtCoderPreviewStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'coderUIModel'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'api - instantiation' }
GtCoderPreviewStencilBuilder >> buildDefault [
	<return: #BrStencil or: #BlElement>

	^ BlElement new size: 0@0
]

{ #category : #accessing }
GtCoderPreviewStencilBuilder >> coderUIModel [
	^ coderUIModel
]

{ #category : #accessing }
GtCoderPreviewStencilBuilder >> coderUIModel: aCoderUIModel [
	coderUIModel := aCoderUIModel
]

{ #category : #'api - instantiation' }
GtCoderPreviewStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.
	aStencilExecutor
		push: self coderUIModel
]

{ #category : #initialization }
GtCoderPreviewStencilBuilder >> reset [
	super reset.
	coderUIModel := nil.
]
