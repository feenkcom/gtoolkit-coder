"
I represent an evaluation status of a source code.
I am used by {{gtClass:GtSourceCoderViewModel}}. 
I am an abstract class.
See my subclasses for concrete evaluation statuses: {{gtClass:GtCoderEvaluationStatus | expanded=true | show=#gtSubclassesFor:}}
"
Class {
	#name : #GtCoderEvaluationStatus,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #testing }
GtCoderEvaluationStatus class >> isAbstract [
	^ self name = #GtCoderEvaluationStatus
]

{ #category : #converting }
GtCoderEvaluationStatus >> asDebugSessionInSpaceEvaluationStatusFromAnnouncement: anAnnouncement [
	^ GtCoderNoEvaluationStatus default
]

{ #category : #testing }
GtCoderEvaluationStatus >> hasDebugSessionInSpace [
	^ false
]

{ #category : #testing }
GtCoderEvaluationStatus >> hasSharedDebugSession [
	^ false
]

{ #category : #'api - hooks' }
GtCoderEvaluationStatus >> mayCloseSourceCoderViewModel: aViewModel debuggerSpaceOfStatus: anEvaluationStatus [
]

{ #category : #'api - hooks' }
GtCoderEvaluationStatus >> mayTerminateSourceCoderViewModel: aViewModel sharedDebugSessionOfStatus: anEvaluationStatus [
]

{ #category : #'api - hooks' }
GtCoderEvaluationStatus >> onSourceCoderElement: anElement [
	
]

{ #category : #'api - hooks' }
GtCoderEvaluationStatus >> sourceCoderViewModel: aViewModel evaluationStatusChangedTo: aNewStatus [
	
]