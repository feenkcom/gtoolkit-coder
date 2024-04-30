Class {
	#name : #GtSourceCoderViewModelEvaluationStatusChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'evaluationStatus'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderViewModelEvaluationStatusChanged >> evaluationStatus [
	^ evaluationStatus
]

{ #category : #accessing }
GtSourceCoderViewModelEvaluationStatusChanged >> evaluationStatus: anObject [
	evaluationStatus := anObject
]
