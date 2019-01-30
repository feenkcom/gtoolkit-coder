Class {
	#name : #GtTextEditorUnhandledError,
	#superclass : #UnhandledError,
	#instVars : [
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #handling }
GtTextEditorUnhandledError >> debug [
	"open a debugger on myself embedded in the given text editor"
	UIManager default
		gtDebugProcess: Processor activeProcess  
		context: self exception signalerContext
		withEmbeddedDebuggerIn: sourceCoder
		forException: self exception
]

{ #category : #'priv handling' }
GtTextEditorUnhandledError >> defaultAction [
	<reflective: #unhandledErrorDefaultAction:message:>
 	^ UIManager default unhandledErrorDefaultAction: self
]

{ #category : #accessing }
GtTextEditorUnhandledError >> sourceCoder: aSourceCoder [
	sourceCoder := aSourceCoder
]
