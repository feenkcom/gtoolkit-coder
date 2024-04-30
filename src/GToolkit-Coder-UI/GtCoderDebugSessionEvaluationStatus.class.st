"
I am a {{gtClass:GtCoderEvaluationStatus}}.
I represent an evaluation status for a source code that was was executed and resulted to an unhandled exception.

"
Class {
	#name : #GtCoderDebugSessionEvaluationStatus,
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

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> exception [
	^ exception
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> exception: anObject [
	exception := anObject
]

{ #category : #testing }
GtCoderDebugSessionEvaluationStatus >> hasSharedDebugSession [
	^ true
]

{ #category : #'api - hooks' }
GtCoderDebugSessionEvaluationStatus >> onSourceCoderElement: anElement [
	"This code must be called from a coder element (or moved to an element), listening to GtSourceCoderViewModelEvaluationStatusChanged."
	anElement
		showNotification: (GtNotificationDebugSession new debugSession: self sharedDebugSession)
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> sharedDebugSession [
	^ sharedDebugSession
]

{ #category : #'private - announcement handling' }
GtCoderDebugSessionEvaluationStatus >> sharedDebugSession: aSharedDebugSession [
	sharedDebugSession := aSharedDebugSession
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtCoderDebugSessionEvaluationStatus >> sourceString: anObject [
	sourceString := anObject
]
