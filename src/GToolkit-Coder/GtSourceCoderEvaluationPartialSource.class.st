Class {
	#name : #GtSourceCoderEvaluationPartialSource,
	#superclass : #GtSourceCoderEvaluationSourceInterval,
	#instVars : [
		'startPosition',
		'stopPosition'
	],
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #evaluation }
GtSourceCoderEvaluationPartialSource >> computeSourceInterval: aCompleteCoderSourceTextOrString [
	<return: #Interval>

	^ (self startPosition min: aCompleteCoderSourceTextOrString size)
		to: (self stopPosition min: aCompleteCoderSourceTextOrString size)
]

{ #category : #evaluation }
GtSourceCoderEvaluationPartialSource >> computeSourceString: aCompleteCoderSourceTextOrString [
	<return: #String>
	| anInterval |
	
	anInterval := self computeSourceInterval: aCompleteCoderSourceTextOrString.

	^ (aCompleteCoderSourceTextOrString copyFrom: anInterval first to: anInterval last) asString
]

{ #category : #accessing }
GtSourceCoderEvaluationPartialSource >> startPosition [
	^ startPosition
]

{ #category : #accessing }
GtSourceCoderEvaluationPartialSource >> startPosition: anObject [
	startPosition := anObject
]

{ #category : #accessing }
GtSourceCoderEvaluationPartialSource >> stopPosition [
	^ stopPosition
]

{ #category : #accessing }
GtSourceCoderEvaluationPartialSource >> stopPosition: anObject [
	stopPosition := anObject
]
