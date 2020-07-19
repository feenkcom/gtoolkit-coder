Class {
	#name : #GtCoderMethodSourceCode,
	#superclass : #GtCoderSourceCode,
	#instVars : [
		'classOrMetaClass',
		'methodSource'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderMethodSourceCode >> classOrMetaClass [
	^ classOrMetaClass
]

{ #category : #accessing }
GtCoderMethodSourceCode >> classOrMetaClass: anObject [
	classOrMetaClass := anObject
]

{ #category : #accessing }
GtCoderMethodSourceCode >> methodSource [
	^ methodSource
]

{ #category : #accessing }
GtCoderMethodSourceCode >> methodSource: anObject [
	methodSource := anObject
]
