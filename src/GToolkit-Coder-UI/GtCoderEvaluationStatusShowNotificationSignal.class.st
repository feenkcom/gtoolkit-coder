Class {
	#name : #GtCoderEvaluationStatusShowNotificationSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'evaluationStatus',
		'announcement',
		'sourceCoderElement'
	],
	#category : 'GToolkit-Coder-UI-Signals'
}

{ #category : #testing }
GtCoderEvaluationStatusShowNotificationSignal class >> gtNormalOperationSignal [
	"Answer a Boolean indicating whether this signal is generated as part of normal operations.
	See {{gtMethod:BeaconSignal class>>gtNormalOperationSignal}} for a description"

	^ true.
]

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
