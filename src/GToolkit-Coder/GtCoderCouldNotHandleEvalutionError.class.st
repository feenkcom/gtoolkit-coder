"
I am used to indicate that {{gtClass:GtCoderEvaluationUnhandledError}} error cannot be handled a standard way, e.g., opening a debugger window. When we simulate UI interactions using {{gtClass:BlScripter}}, we cannot open a debugger window as it suspends the Scripter's UI process and an example evaluator waits indefinitely for the example to finish.
"
Class {
	#name : #GtCoderCouldNotHandleEvalutionError,
	#superclass : #Error,
	#instVars : [
		'unhandledError'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderCouldNotHandleEvalutionError >> unhandledError [
	^ unhandledError
]

{ #category : #accessing }
GtCoderCouldNotHandleEvalutionError >> unhandledError: anObject [
	unhandledError := anObject
]
