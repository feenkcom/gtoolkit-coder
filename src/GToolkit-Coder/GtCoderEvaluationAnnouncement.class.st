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
	^ evaluationResult
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> evaluationResult: anObject [
	evaluationResult := anObject
]
