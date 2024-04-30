"
I am a {{gtClass:GtCoderEvaluationStatus}}.
I represent an evaluation status for a source code that was not executed.

"
Class {
	#name : #GtCoderNoEvaluationStatus,
	#superclass : #GtCoderEvaluationStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #'api - hooks' }
GtCoderNoEvaluationStatus >> mayTerminateDebugSession: aDebugSession [
	aDebugSession terminate
]

{ #category : #'api - hooks' }
GtCoderNoEvaluationStatus >> mayTerminateSharedDebugSession: aSharedDebugSession [
	aSharedDebugSession terminate
]
