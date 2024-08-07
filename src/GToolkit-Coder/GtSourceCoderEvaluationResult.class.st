Class {
	#name : #GtSourceCoderEvaluationResult,
	#superclass : #Object,
	#instVars : [
		'evaluationContext'
	],
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #accessing }
GtSourceCoderEvaluationResult >> evaluatedCode [
	"Return an object, representing the evaluated source string.
	For example in case of Pharo, it is a reference to a compiled method."

	<return: #TGtSourceCoderEvaluatedCode>
	^ self evaluationContext evaluatedCode
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> evaluationContext [
	^ evaluationContext
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> evaluationContext: anObject [
	evaluationContext := anObject
]

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
	<return: #TGtCoderRequesterObject>
	^ self evaluationContext requesterObject
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceCoder [
	^ self evaluationContext coder
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceInterval [
	^ self evaluationContext evaluatedInterval
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceInterval: anObject [
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceString [
	^ self evaluationContext evaluatedSourceString
]

{ #category : #accessing }
GtSourceCoderEvaluationResult >> sourceString: anObject [
]
