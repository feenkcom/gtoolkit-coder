Class {
	#name : #GtSourceCoderEvaluationResult,
	#superclass : #Object,
	#instVars : [
		'sourceCoder',
		'sourceString',
		'sourceInterval',
		'requesterObject'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #testing }
GtSourceCoderEvaluationResult >> isError [
	^ self isRuntimeError or: [ self isSyntaxError ]
]

{ #category : #testing }
GtSourceCoderEvaluationResult >> isRuntimeError [
	^ false
]

{ #category : #testing }
GtSourceCoderEvaluationResult >> isSuccess [
	^ false
]

{ #category : #testing }
GtSourceCoderEvaluationResult >> isSyntaxError [
	^ false
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> requesterObject [
	^ requesterObject
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> requesterObject: anObject [
	requesterObject := anObject
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceCoder [
	^ sourceCoder
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceCoder: aGtSourceCoder [
	sourceCoder := aGtSourceCoder.
	sourceString := sourceCoder currentSourceString.
	sourceInterval := 1 to: sourceString size
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceString: anObject [
	sourceString := anObject
]
