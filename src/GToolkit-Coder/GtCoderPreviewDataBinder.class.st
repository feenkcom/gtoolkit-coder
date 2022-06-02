Class {
	#name : #GtCoderPreviewDataBinder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'element',
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #'api - instantiation' }
GtCoderPreviewDataBinder >> buildDefault [
	<return: #BrStencil or: #BlElement>

	^ BlElement new size: 0@0
]

{ #category : #accessing }
GtCoderPreviewDataBinder >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderPreviewDataBinder >> coderViewModel: aCoderViewModel [
	coderViewModel := aCoderViewModel
]

{ #category : #accessing }
GtCoderPreviewDataBinder >> element [

	^ element
]

{ #category : #accessing }
GtCoderPreviewDataBinder >> element: anObject [

	element := anObject
]

{ #category : #'api - instantiation' }
GtCoderPreviewDataBinder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.

	aStencilExecutor
		push: self element;
		push: self coderViewModel
]

{ #category : #initialization }
GtCoderPreviewDataBinder >> reset [
	element := nil.
	coderViewModel := nil.
]
