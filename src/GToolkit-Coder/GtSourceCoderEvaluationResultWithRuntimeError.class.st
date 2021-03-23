Class {
	#name : #GtSourceCoderEvaluationResultWithRuntimeError,
	#superclass : #GtSourceCoderEvaluationResult,
	#instVars : [
		'error',
		'isResignaled'
	],
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #'error handling' }
GtSourceCoderEvaluationResultWithRuntimeError >> error [
	^ error
]

{ #category : #'error handling' }
GtSourceCoderEvaluationResultWithRuntimeError >> error: anError [
	error := anError
]

{ #category : #accessing }
GtSourceCoderEvaluationResultWithRuntimeError >> isResignaled [
	^ isResignaled
]

{ #category : #accessing }
GtSourceCoderEvaluationResultWithRuntimeError >> isResignaled: anObject [
	isResignaled := anObject
]

{ #category : #testing }
GtSourceCoderEvaluationResultWithRuntimeError >> isRuntimeError [
	^ true
]
