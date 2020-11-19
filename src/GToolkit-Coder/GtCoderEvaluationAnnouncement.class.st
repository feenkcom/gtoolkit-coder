Class {
	#name : #GtCoderEvaluationAnnouncement,
	#superclass : #GtCoderAnnouncement,
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
