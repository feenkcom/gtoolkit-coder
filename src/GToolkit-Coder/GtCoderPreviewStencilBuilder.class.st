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
GtCoderPreviewStencilBuilder >> coderViewModel [
	^ coderUIModel
]

{ #category : #accessing }
GtCoderPreviewStencilBuilder >> coderViewModel: aCoderViewModel [
	coderUIModel := aCoderViewModel
]

{ #category : #'api - instantiation' }
GtCoderPreviewStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.
	aStencilExecutor
		push: self coderViewModel
]

{ #category : #initialization }
GtCoderPreviewStencilBuilder >> reset [
	super reset.
	coderUIModel := nil.
]
