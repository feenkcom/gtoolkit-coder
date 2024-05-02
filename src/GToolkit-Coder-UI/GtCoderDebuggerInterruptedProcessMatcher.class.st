Class {
	#name : #GtCoderDebuggerInterruptedProcessMatcher,
	#superclass : #GtCoderDebuggerMatcher,
	#instVars : [
		'process'
	],
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #testing }
GtCoderDebuggerInterruptedProcessMatcher >> isMoldableDebugger: anElement [
	| anElementDebugSession |
	anElementDebugSession := anElement debugSession.
	^ anElementDebugSession isNotNil
		and: [ anElementDebugSession interruptedProcess == process ]
]

{ #category : #accessing }
GtCoderDebuggerInterruptedProcessMatcher >> process [
	^ process
]

{ #category : #accessing }
GtCoderDebuggerInterruptedProcessMatcher >> process: anObject [
	process := anObject
]
