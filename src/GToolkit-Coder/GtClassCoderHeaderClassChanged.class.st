"
A header is now opened on a new class, we should completely recreate a header UI
"
Class {
	#name : #GtClassCoderHeaderClassChanged,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'theClass'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderClassChanged >> theClass [
	^ theClass
]

{ #category : #accessing }
GtClassCoderHeaderClassChanged >> theClass: anObject [
	theClass := anObject
]
