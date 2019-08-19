Class {
	#name : #GtCoderEvaluationUnhandledError,
	#superclass : #UnhandledError,
	#instVars : [
		'sourceCoder'
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
		forException: self exception
]

{ #category : #'priv handling' }
GtCoderEvaluationUnhandledError >> defaultAction [
	<reflective: #unhandledErrorDefaultAction:message:>
 	^ UIManager default unhandledErrorDefaultAction: self
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceCoder: aSourceCoder [
	sourceCoder := aSourceCoder
]
