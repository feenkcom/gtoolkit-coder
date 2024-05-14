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
		'sharedDebugSession',
		'evaluatedCode'
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
GtCoderEmbeddedDebugSessionEvaluationStatus >> evaluatedCode [
	<return: #TGtSourceCoderEvaluatedCode>
	^ evaluatedCode ifNil: [
		evaluatedCode := GtSourceCoderNoEvaluatedCode default ]
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> evaluatedCode: anObject [
	evaluatedCode := anObject
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> evaluatedCodeContext [
	"Return a stack context that corresponds to a given evaluated code."

	<return: #Context or: nil>
	self sharedDebugSession
		sessionDo: [ :aSession | ^ self evaluatedCode findRelevantContextInStack: aSession context stack ].
	^ nil
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> evaluatedCodeInterval [
	"Return an interval that corresponds to a given evaluated code."

	<return: #Interval or: nil>
	| aContext |
	aContext := self evaluatedCodeContext.
	aContext ifNil: [ ^ nil ].

	(self debugSession process isNil or: [ aContext isDead ]) ifTrue: [ ^ nil ].

	^ self
		forPharo11OrNewer: [ self debugSession pcRangeForContext: aContext ]
		forPharo10: [ | aUsedAst anInterval |
			aUsedAst := self evaluatedCode findSourceAstForContext: aContext.
			anInterval := GtPharoMethodNodeSourceIntervalFinder new
					methodNode: aUsedAst;
					sourceString: self sourceString;
					find.
			anInterval last isZero ifTrue: [ nil ] ifFalse: [ anInterval ] ]
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> exception [
	^ exception
]

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> exception: anObject [
	exception := anObject
]

{ #category : #printing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'Embedded debugger('.
	stream print: exception.
	stream nextPut: $)
]

{ #category : #'gt - extensions' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> gtEvaluatedSource [
	| aText |
	aText := self sourceString asRopedText glamorousCodeFontAndSize.

	self evaluatedCodeInterval
		ifNotNil: [ :aContextInterval | 
			| aContextMin aContextMax |
			aContextMin := aContextInterval first min: aText size.
			aContextMax := aContextInterval last min: aText size.
			(aText from: aContextMin to: aContextMax)
				highlight: BrGlamorousColors debuggerTextHighlightColor ].

	^ aText
]

{ #category : #'gt - extensions' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> gtEvaluatedSourceFor: aView [
	<gtView>
	sourceString ifNil: [ ^ aView empty ].

	^ aView text
		title: 'Evaluated source';
		text: [ self gtEvaluatedSource ]
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

{ #category : #accessing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sharedDebugSession [
	^ sharedDebugSession
]

{ #category : #'private - announcement handling' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sharedDebugSession: aSharedDebugSession [
	sharedDebugSession := aSharedDebugSession
]

{ #category : #'api - hooks' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> sourceCoderViewModel: aViewModel evaluationStatusChangedTo: aNewStatus [
	aNewStatus
		mayTerminateSourceCoderViewModel: aViewModel
		sharedDebugSessionOfStatus: self
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
