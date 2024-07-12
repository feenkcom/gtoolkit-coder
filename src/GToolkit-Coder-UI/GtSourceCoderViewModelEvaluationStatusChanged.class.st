Class {
	#name : #GtSourceCoderViewModelEvaluationStatusChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'evaluationStatus',
		'isNotificationHandled'
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

{ #category : #accessing }
GtSourceCoderViewModelEvaluationStatusChanged >> isNotificationHandled [
	"Indicates, whether a user notification, e.g., debug session notification, was requested (and therefore displayed)."

	^ isNotificationHandled ifNil: [ isNotificationHandled := false ]
]

{ #category : #accessing }
GtSourceCoderViewModelEvaluationStatusChanged >> isNotificationHandled: aBoolean [
	isNotificationHandled := aBoolean
]
