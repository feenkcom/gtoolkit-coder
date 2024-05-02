"
I am a {{gtClass:GtCoderEvaluationStatus}}.
I represent an evaluation status for a source code that was executed and resulted to an unhandled exception. The corresponding process is suspended and waiting for a user action, e.g., opening in a debugger.

"
Class {
	#name : #GtCoderEmbeddedDebugSessionEvaluationStatus,
	#superclass : #GtCoderEvaluationStatus,
	#instVars : [
		'debugSession',
		'exception',
		'sourceInterval',
		'sourceString',
		'sharedDebugSession'
	],
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #converting }
GtCoderEmbeddedDebugSessionEvaluationStatus >> asDebugSessionInSpaceEvaluationStatusFromAnnouncement: anAnnouncement [
	^ GtCoderDebugSessionInSpaceEvaluationStatus new
		debugSession: anAnnouncement releasedSession;
		debugger: anAnnouncement debugger;
		sourceInterval: self sourceInterval;
		sourceString: self sourceString
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> exception [
	^ exception
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> exception: anObject [
	exception := anObject
]

{ #category : #testing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> hasSharedDebugSession [
	^ true
]

{ #category : #'api - hooks' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> onSourceCoderElement: anElement [
	"This code must be called from a coder element (or moved to an element), listening to GtSourceCoderViewModelEvaluationStatusChanged."
	anElement
		showNotification: (GtNotificationDebugSession new debugSession: self sharedDebugSession)
]

{ #category : #'api - hooks' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> onSourceCoderViewModel: aViewModel changedToStatus: aNewStatus [
	aNewStatus mayTerminateSharedDebugSessionOfStatus: self
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sharedDebugSession [
	^ sharedDebugSession
]

{ #category : #'private - announcement handling' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sharedDebugSession: aSharedDebugSession [
	sharedDebugSession := aSharedDebugSession
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sourceString: anObject [
	sourceString := anObject
]
