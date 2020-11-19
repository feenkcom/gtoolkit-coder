Class {
	#name : #GtSourceCoderEvaluationResultWithValue,
	#superclass : #GtSourceCoderEvaluationResult,
	#instVars : [
		'value'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #testing }
GtSourceCoderEvaluationResultWithValue >> isSuccess [
	^ true
]

{ #category : #accessing }
GtSourceCoderEvaluationResultWithValue >> value [
	^ value
]

{ #category : #accessing }
GtSourceCoderEvaluationResultWithValue >> value: anObject [
	value := anObject
]
