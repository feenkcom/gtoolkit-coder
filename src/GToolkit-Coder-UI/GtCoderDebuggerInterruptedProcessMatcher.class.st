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
	^ anElement debugSession interruptedProcess == process
]

{ #category : #accessing }
GtCoderDebuggerInterruptedProcessMatcher >> process [
	^ process
]

{ #category : #accessing }
GtCoderDebuggerInterruptedProcessMatcher >> process: anObject [
	process := anObject
]
