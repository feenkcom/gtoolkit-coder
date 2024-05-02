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

{ #category : #printing }
GtCoderNoEvaluationStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'No evaluation'
]

{ #category : #'api - hooks' }
GtCoderNoEvaluationStatus >> mayCloseSourceCoderViewModel: aViewModel debuggerSpaceOfStatus: anEvaluationStatus [
	
]

{ #category : #'api - hooks' }
GtCoderNoEvaluationStatus >> mayTerminateSourceCoderViewModel: aViewModel sharedDebugSessionOfStatus: anEvaluationStatus [
	anEvaluationStatus sharedDebugSession unsubscribe: aViewModel.
	anEvaluationStatus sharedDebugSession terminate
]
