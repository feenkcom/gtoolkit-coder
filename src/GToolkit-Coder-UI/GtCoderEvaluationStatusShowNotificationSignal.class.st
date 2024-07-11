Class {
	#name : #GtCoderEvaluationStatusShowNotificationSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'evaluationStatus',
		'announcement',
		'sourceCoderElement'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderEvaluationStatusShowNotificationSignal >> announcement [
	^ announcement
]

{ #category : #accessing }
GtCoderEvaluationStatusShowNotificationSignal >> announcement: anObject [
	announcement := anObject
]

{ #category : #accessing }
GtCoderEvaluationStatusShowNotificationSignal >> evaluationStatus [
	^ evaluationStatus
]

{ #category : #accessing }
GtCoderEvaluationStatusShowNotificationSignal >> evaluationStatus: anObject [
	evaluationStatus := anObject
]

{ #category : #accessing }
GtCoderEvaluationStatusShowNotificationSignal >> sourceCoderElement [
	^ sourceCoderElement
]

{ #category : #accessing }
GtCoderEvaluationStatusShowNotificationSignal >> sourceCoderElement: anObject [
	sourceCoderElement := anObject
]
