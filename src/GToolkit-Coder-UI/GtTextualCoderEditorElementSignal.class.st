Class {
	#name : #GtTextualCoderEditorElementSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'element'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #testing }
GtTextualCoderEditorElementSignal class >> gtNormalOperationSignal [
	"Answer a Boolean indicating whether this signal is generated as part of normal operations.
	Excluding these signals makes a good starting point for application specific logging, or logging unexpected signals"

	^ true.
]

{ #category : #accessing }
GtTextualCoderEditorElementSignal >> element [
	^ element
]

{ #category : #accessing }
GtTextualCoderEditorElementSignal >> element: anObject [
	element := anObject
]
