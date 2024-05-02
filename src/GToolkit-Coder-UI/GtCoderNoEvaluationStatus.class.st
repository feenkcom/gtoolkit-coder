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
GtCoderNoEvaluationStatus >> mayCloseDebuggerOfStatus: anEvaluationStatus [
	
]

{ #category : #'api - hooks' }
GtCoderNoEvaluationStatus >> mayTerminateSharedDebugSessionOfStatus: anEvaluationStatus [
	anEvaluationStatus sharedDebugSession terminate
]
