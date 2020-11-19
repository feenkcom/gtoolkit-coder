Class {
	#name : #GtCoderEvaluationUnhandledError,
	#superclass : #UnhandledError,
	#instVars : [
		'sourceCoder',
		'sourceString',
		'sourceInterval'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #handling }
GtCoderEvaluationUnhandledError >> debug [
	"Request a debugger on myself embedded in the given text editor"

	UIManager default
		gtDebugProcess: Processor activeProcess
		context: self exception signalerContext
		withEmbeddedDebuggerIn: sourceCoder
		withSourceString: self sourceString
		withSourceInterval: self sourceInterval
		forException: self exception
]

{ #category : #'priv handling' }
GtCoderEvaluationUnhandledError >> defaultAction [
	<reflective: #unhandledErrorDefaultAction:message:>
 	^ UIManager default unhandledErrorDefaultAction: self
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceCoder [
	^ sourceCoder
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceCoder: aSourceCoder [
	sourceCoder := aSourceCoder
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceString: anObject [
	sourceString := anObject
]
