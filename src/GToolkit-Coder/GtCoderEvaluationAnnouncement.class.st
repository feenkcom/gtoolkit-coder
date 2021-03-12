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

{ #category : #testing }
GtCoderEvaluationAnnouncement >> isRequestedByElementOrItsChild: anElement [
	"Return true if the evaluation ws requested by a given visual element or any of its children"
	<return: #Boolean>

	self requesterObject == anElement
		ifTrue: [ ^ true ].
	
	(self requesterObject isKindOf: BlElement)
		ifFalse: [ ^ false ].
		
	^ self requesterObject hasParent: anElement
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> requesterObject [
	^ self evaluationResult requesterObject
]
