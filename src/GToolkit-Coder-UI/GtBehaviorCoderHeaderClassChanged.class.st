"
A header is now opened on a new class, we should completely recreate a header UI
"
Class {
	#name : #GtBehaviorCoderHeaderClassChanged,
	#superclass : #BrChangeEvent,
	#instVars : [
		'theClass'
	],
	#category : #'GToolkit-Coder-UI-Behaviour'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassChanged >> theClass [
	^ theClass
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassChanged >> theClass: anObject [
	theClass := anObject
]
