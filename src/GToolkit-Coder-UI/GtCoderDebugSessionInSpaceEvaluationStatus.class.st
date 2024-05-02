"
I am a {{gtClass:GtCoderEvaluationStatus}}.
I represent an evaluation status for a source code that was executed and resulted to an unhandled exception.
The corresponding process is opened in a debugger.
"
Class {
	#name : #GtCoderDebugSessionInSpaceEvaluationStatus,
	#superclass : #GtCoderEvaluationStatus,
	#instVars : [
		'debugSession',
		'debugger',
		'sourceInterval',
		'sourceString'
	],
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #converting }
GtCoderDebugSessionInSpaceEvaluationStatus >> asDebugSessionInSpaceEvaluationStatusFromAnnouncement: anAnnouncement [
	^ GtCoderDebugSessionInSpaceEvaluationStatus new
		debugSession: anAnnouncement releasedSession;
		debugger: anAnnouncement debugger;
		sourceInterval: self sourceInterval;
		sourceString: self sourceString
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> debugger [
	^ debugger
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> debugger: anObject [
	debugger := anObject
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> debuggerSpace [
	<return: #BlSpace or: nil>
	^ GtCoderDebuggerSpaceFinder new
		debugSession: self debugSession;
		find;
		space
]

{ #category : #testing }
GtCoderDebugSessionInSpaceEvaluationStatus >> hasDebugSessionInSpace [
	^ true
]

{ #category : #'api - hooks' }
GtCoderDebugSessionInSpaceEvaluationStatus >> onSourceCoderViewModel: aViewModel changedToStatus: aNewStatus [
	aNewStatus mayCloseDebuggerOfStatus: self
]

{ #category : #actions }
GtCoderDebugSessionInSpaceEvaluationStatus >> requestDebuggerSpaceClose [
	^ self debuggerSpace ifNotNil: #requestClose
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> sourceString: anObject [
	sourceString := anObject
]
