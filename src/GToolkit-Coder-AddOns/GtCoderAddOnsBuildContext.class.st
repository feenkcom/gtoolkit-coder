"
My main purpose is to pass information while building coder addOns without having to add more method parameters.
"
Class {
	#name : #GtCoderAddOnsBuildContext,
	#superclass : #Object,
	#instVars : [
		'documentId',
		'astNode',
		'editorElement',
		'sourceCoderViewModel'
	],
	#category : #'GToolkit-Coder-AddOns-Support'
}

{ #category : #accessing }
GtCoderAddOnsBuildContext >> astNode [
	^ astNode
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> astNode: anObject [
	astNode := anObject
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> documentId [
	^ documentId
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> documentId: anObject [
	documentId := anObject
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> editorElement [
	^ editorElement
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> editorElement: anObject [
	editorElement := anObject
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> sourceCoderViewModel [
	^ sourceCoderViewModel
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> sourceCoderViewModel: anObject [
	sourceCoderViewModel := anObject
]
