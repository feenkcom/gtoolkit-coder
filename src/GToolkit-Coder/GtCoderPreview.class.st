Class {
	#name : #GtCoderPreview,
	#superclass : #Object,
	#instVars : [
		'title',
		'stencilBuilder'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderPreview >> stencil: aStencilBuilder [

	stencilBuilder := aStencilBuilder asStencilBuilder:
		                  GtCoderPreviewStencilBuilder
]

{ #category : #accessing }
GtCoderPreview >> stencilBuilder [

	^ stencilBuilder
]

{ #category : #accessing }
GtCoderPreview >> title [

	^ title
]

{ #category : #accessing }
GtCoderPreview >> title: aString [

	title := aString
]
