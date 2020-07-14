"
I represent a concrete source code that was provided as a string
"
Class {
	#name : #GtCoderConcreteSourceCode,
	#superclass : #GtCoderSourceCode,
	#instVars : [
		'sourceCode'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderConcreteSourceCode >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtCoderConcreteSourceCode >> sourceCode: anObject [
	sourceCode := anObject
]
