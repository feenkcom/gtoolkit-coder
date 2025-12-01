Class {
	#name : #GtCoderEvaluationUnhandledError,
	#superclass : #UnhandledError,
	#instVars : [
		'sourceCoder',
		'sourceString',
		'sourceInterval',
		'requesterObject',
		'evaluatedCode'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #handling }
GtCoderEvaluationUnhandledError >> debug [
	"Request a debugger on myself embedded in the given text editor"

	UIManager default
		gtDebugProcess: Processor activeProcess
		context: self exception signalerContext
		withEmbeddedDebuggerIn: requesterObject
		withSourceString: self sourceString
		withSourceInterval: self sourceInterval
		forException: self exception
		evaluationInfo: (GtCoderEvaluationUnhandledErrorInformation new
			requesterObject: self requesterObject;
			evaluatedCode: self evaluatedCode;
			sourceString: self sourceString;
			sourceInterval: self sourceInterval;
			sourceCoder: self sourceCoder)
]

{ #category : #'priv handling' }
GtCoderEvaluationUnhandledError >> defaultAction [
	"We do not want to handle this exception if executed within a scripter.
	The reason is that we do not want to open an embedded debuger as it stops
	the Scripter's UI process and creates a new one. As a consequence,
	an example execution is stopped and example runners (Jenkins, CI) is waiting
	indefinitely."

	<reflective: #unhandledErrorDefaultAction:message:>
	^ BlDevScripterStepExecutionIndicator
		ifScripter: [ super defaultAction ]
		ifNone: [ UIManager default unhandledErrorDefaultAction: self ]
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> evaluatedCode [
	<return: #TGtSourceCoderEvaluatedCode>
	^ evaluatedCode ifNil: [ 
		evaluatedCode := GtSourceCoderNoEvaluatedCode default ]
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> evaluatedCode: aSourceCode [
	evaluatedCode := aSourceCode
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> requesterObject [
	"Return an object that requested evaluation."

	<return: #TGtCoderRequesterObject>
	^ requesterObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> requesterObject: anObject [
	requesterObject := anObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledError >> sourceCoder [
	<return: #GtSourceCoder>
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
