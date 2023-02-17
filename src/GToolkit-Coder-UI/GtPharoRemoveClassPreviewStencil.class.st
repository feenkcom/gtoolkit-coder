Class {
	#name : #GtPharoRemoveClassPreviewStencil,
	#superclass : #GtAbstractRemovePreviewStencil,
	#instVars : [
		'classToRemove'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtPharoRemoveClassPreviewStencil >> anElement: element [
	anElement := element
]

{ #category : #initialization }
GtPharoRemoveClassPreviewStencil >> classToRemove: aClass [
	classToRemove := aClass
]

{ #category : #accessing }
GtPharoRemoveClassPreviewStencil >> create [
	^ self
		createPreviewContainerForItemNamed: classToRemove name
		withReferences: classToRemove gtReferences
]
