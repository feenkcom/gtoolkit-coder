Class {
	#name : #GtCoderPreview,
	#superclass : #Object,
	#instVars : [
		'id',
		'title',
		'stencil',
		'dataBinder'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #comparing }
GtCoderPreview >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ id = anObject id
]

{ #category : #accessing }
GtCoderPreview >> dataBinder [

	^ dataBinder
]

{ #category : #accessing }
GtCoderPreview >> dataBinder: aStencil [
	dataBinder := aStencil asStencilBuilder: GtCoderPreviewDataBinder
]

{ #category : #comparing }
GtCoderPreview >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ id hash
]

{ #category : #accessing }
GtCoderPreview >> id [

	^ id
]

{ #category : #accessing }
GtCoderPreview >> id: anObject [
	"Assign an action id which is used to uniquely identify an action"

	id := anObject
]

{ #category : #accessing }
GtCoderPreview >> stencil [
	^ stencil
]

{ #category : #accessing }
GtCoderPreview >> stencil: aStencil [
	stencil := aStencil asStencil
]

{ #category : #accessing }
GtCoderPreview >> stencilBuilder [
	^ self stencil
]

{ #category : #accessing }
GtCoderPreview >> title [

	^ title
]

{ #category : #accessing }
GtCoderPreview >> title: aString [

	title := aString
]
