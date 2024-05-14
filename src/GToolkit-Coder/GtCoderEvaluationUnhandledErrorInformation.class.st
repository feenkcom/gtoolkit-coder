"
I hold extra information that is passed by {{gtClass:GtCoderEvaluationUnhandledError}} to handle (debug) unhandled exceptions. 
"
Class {
	#name : #GtCoderEvaluationUnhandledErrorInformation,
	#superclass : #Object,
	#instVars : [
		'requesterObject',
		'evaluatedCode',
		'sourceString',
		'sourceInterval',
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> evaluatedCode [
	<return: #TGtSourceCoderEvaluatedCode>
	^ evaluatedCode ifNil: [ 
		evaluatedCode := GtSourceCoderNoEvaluatedCode default ]
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> evaluatedCode: anObject [
	evaluatedCode := anObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> requesterObject [
	"Return an object that requested evaluation."

	<return: #TGtCoderRequesterObject>
	^ requesterObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> requesterObject: anObject [
	requesterObject := anObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> sourceCoder [
	<return: #GtSourceCoder>
	^ sourceCoder
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> sourceCoder: anObject [
	sourceCoder := anObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtCoderEvaluationUnhandledErrorInformation >> sourceString: anObject [
	sourceString := anObject
]
