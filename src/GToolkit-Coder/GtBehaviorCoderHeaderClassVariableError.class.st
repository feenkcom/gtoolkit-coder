Class {
	#name : #GtBehaviorCoderHeaderClassVariableError,
	#superclass : #GtBehaviorCoderHeaderError,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #signalling }
GtBehaviorCoderHeaderClassVariableError class >> signalFor: aVariableName [
	(self new variableName: aVariableName) signal
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVariableError >> variableName [
	^ variableName
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVariableError >> variableName: anObject [
	variableName := anObject
]
