Class {
	#name : #GtCoderUpdateMultipleCursorsSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'editorElement',
		'cursors'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderUpdateMultipleCursorsSignal >> cursors [
	^ cursors
]

{ #category : #accessing }
GtCoderUpdateMultipleCursorsSignal >> cursors: anObject [
	cursors := anObject
]

{ #category : #accessing }
GtCoderUpdateMultipleCursorsSignal >> editorElement [
	^ editorElement
]

{ #category : #accessing }
GtCoderUpdateMultipleCursorsSignal >> editorElement: anObject [
	editorElement := anObject
]
