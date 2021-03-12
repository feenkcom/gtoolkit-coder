Class {
	#name : #GtSourceCoderViewModelEvaluationAnnouncement,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'evaluationResult',
		'source'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtSourceCoderViewModelEvaluationAnnouncement >> evaluationResult [
	<return: #GtSourceCoderEvaluationResult>

	^ evaluationResult
]

{ #category : #accessing }
GtSourceCoderViewModelEvaluationAnnouncement >> evaluationResult: aGtSourceCoderEvaluationResult [
	evaluationResult := aGtSourceCoderEvaluationResult
]
