Class {
	#name : #GtCoderEvaluationAnnouncement,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'evaluationResult'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> evaluationResult [
	<return: #GtSourceCoderEvaluationResult>

	^ evaluationResult
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> evaluationResult: aGtSourceCoderEvaluationResult [
	evaluationResult := aGtSourceCoderEvaluationResult
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> requesterObject [
	<return: #TGtCoderRequesterObject>
	^ self evaluationResult requesterObject
]
