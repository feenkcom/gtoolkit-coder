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

{ #category : #comparing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self debugSession = anObject debugSession
		and: [ self sharedDebugSession = anObject sharedDebugSession
		and: [ self exception = anObject exception
		and: [ self evaluatedCode = anObject evaluatedCode
		and: [ self sourceInterval = anObject sourceInterval
		and: [ self sourceString = anObject sourceString ] ] ] ] ]
]

{ #category : #converting }
GtCoderEmbeddedDebugSessionEvaluationStatus >> asDebugSessionInSpaceEvaluationStatusFromAnnouncement: anAnnouncement [
	^ GtCoderDebugSessionInSpaceEvaluationStatus new
		debugSession: anAnnouncement releasedSession;
		debugger: anAnnouncement debugger;
		sourceInterval: self sourceInterval;
		sourceString: self sourceString;
		evaluatedCode: self evaluatedCode
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
	^ GtCoderEvaluatedCodeIntervalFinder new
		debugSession: self debugSession;
		context: self evaluatedCodeContext;
		evaluatedCode: self evaluatedCode;
		sourceString: self sourceString;
		find
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
		priority: 20;
		text: [ self gtEvaluatedSource ]
]

{ #category : #'api - hooks' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> handleStatusChangedAnnouncement: anAnnouncement sourceCoderElement: anElement [
	"I request to display a debug session notification. This method must be called 
	from an element, listening to GtSourceCoderViewModelEvaluationStatusChanged."

	<return: #Boolean>
	anAnnouncement isNotificationHandled ifTrue: [ ^ self ].
	anAnnouncement isNotificationHandled: true.
	
	GtCoderEvaluationStatusShowNotificationSignal new
		evaluationStatus: self;
		announcement: anAnnouncement;
		sourceCoderElement: anElement;
		emit.
	
	anElement
		showNotification: (GtNotificationDebugSession new debugSession: self sharedDebugSession)
]

{ #category : #testing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> hasSharedDebugSession [
	^ true
]

{ #category : #comparing }
GtCoderEmbeddedDebugSessionEvaluationStatus >> hash [
	^ self class hash
		bitXor: (self debugSession hash
		bitXor: (self sharedDebugSession hash
		bitXor: (self exception hash
		bitXor: (self evaluatedCode hash
		bitXor: (self sourceInterval hash
		bitXor: (self sourceString hash ))))))
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
