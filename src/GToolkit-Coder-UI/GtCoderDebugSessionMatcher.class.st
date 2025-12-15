Class {
	#name : #GtCoderDebugSessionMatcher,
	#superclass : #GtCoderDebuggerMatcher,
	#instVars : [
		'debugSession'
	],
	#category : 'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #accessing }
GtCoderDebugSessionMatcher >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtCoderDebugSessionMatcher >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #testing }
GtCoderDebugSessionMatcher >> isMoldableDebugger: anElement [
	| anElementDebugSession |
	anElementDebugSession := anElement debugSession.
	^ anElementDebugSession isNotNil
		and: [ anElementDebugSession interruptedProcess == debugSession interruptedProcess ]
]
