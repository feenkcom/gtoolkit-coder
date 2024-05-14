Class {
	#name : #GtSourceCoderRequester,
	#superclass : #Object,
	#traits : 'TGtCoderRequesterObject',
	#classTraits : 'TGtCoderRequesterObject classTrait',
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #accessing }
GtSourceCoderRequester >> coder [
	^ coder
]

{ #category : #accessing }
GtSourceCoderRequester >> coder: anObject [
	coder := anObject
]

{ #category : #'api - notifying' }
GtSourceCoderRequester >> notifyShowDebuggerRequest: aDebugSession dueTo: anException sourceString: aSourceString sourceInterval: aSourceInterval evaluationInfo: anEvaluationInfo [
	"Return true if announcement was handled (and debugger displayed in some way).
	Return false otherwise."

	^ self coder
		notifyShowDebuggerRequest: aDebugSession
		dueTo: anException
		sourceString: aSourceString
		sourceInterval: aSourceInterval
		evaluationInfo: anEvaluationInfo
]
