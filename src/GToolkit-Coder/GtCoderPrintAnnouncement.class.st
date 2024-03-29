Class {
	#name : #GtCoderPrintAnnouncement,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'evaluationResult'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderPrintAnnouncement >> evaluationResult [
	<return: #GtSourceCoderEvaluationResult>

	^ evaluationResult
]

{ #category : #accessing }
GtCoderPrintAnnouncement >> evaluationResult: aGtSourceCoderEvaluationResult [
	evaluationResult := aGtSourceCoderEvaluationResult
]

{ #category : #accessing }
GtCoderPrintAnnouncement >> requesterObject [
	<return: #TGtCoderRequesterObject>
	^ self evaluationResult requesterObject
]
