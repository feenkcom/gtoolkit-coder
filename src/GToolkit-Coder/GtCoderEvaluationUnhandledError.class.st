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
	"Open a debugger on myself embedded in the given text editor if the embedded debugger is present in the image.
	If not open the standard debugger."
	
	(Smalltalk tools hasToolNamed: #gtEmbeddableDebugger)
		ifFalse: [ ^ super debug ].
	
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
