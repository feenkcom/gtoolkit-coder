Class {
	#name : #GtSourceCoderUIModel,
	#superclass : #GtCoderUIModel,
	#instVars : [
		'editorState'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderUIModel >> editorState [
	^ editorState
]

{ #category : #accessing }
GtSourceCoderUIModel >> editorState: anObject [
	editorState := anObject
]
