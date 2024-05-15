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
		'sourceString',
		'evaluatedCode'
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

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> evaluatedCode [
	<return: #TGtSourceCoderEvaluatedCode>
	^ evaluatedCode ifNil: [
		evaluatedCode := GtSourceCoderNoEvaluatedCode default ]
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> evaluatedCode: anObject [
	evaluatedCode := anObject
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> evaluatedCodeContext [
	"Return a stack context that corresponds to a given evaluated code."

	<return: #Context or: nil>
	self debugSession process ifNil: [ ^ nil ].

	^ self evaluatedCode findRelevantContextInStack: self debugSession context stack
]

{ #category : #accessing }
GtCoderDebugSessionInSpaceEvaluationStatus >> evaluatedCodeInterval [
	"Return an interval that corresponds to a given evaluated code."

	<return: #Interval or: nil>
	^ GtCoderEvaluatedCodeIntervalFinder new
		debugSession: self debugSession;
		context: self evaluatedCodeContext;
		evaluatedCode: self evaluatedCode;
		sourceString: self sourceString;
		find
]

{ #category : #testing }
GtCoderDebugSessionInSpaceEvaluationStatus >> hasDebugSessionInSpace [
	^ true
]

{ #category : #actions }
GtCoderDebugSessionInSpaceEvaluationStatus >> requestDebuggerSpaceClose [
	^ self debuggerSpace ifNotNil: #requestClose
]

{ #category : #'api - hooks' }
GtCoderDebugSessionInSpaceEvaluationStatus >> sourceCoderViewModel: aViewModel evaluationStatusChangedTo: aNewStatus [
	aNewStatus mayCloseSourceCoderViewModel: aViewModel debuggerSpaceOfStatus: self
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
