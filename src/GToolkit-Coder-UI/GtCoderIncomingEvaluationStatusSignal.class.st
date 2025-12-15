Class {
	#name : #GtCoderIncomingEvaluationStatusSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'viewModel',
		'existingStatus',
		'newStatus'
	],
	#category : 'GToolkit-Coder-UI-Signals'
}

{ #category : #testing }
GtCoderIncomingEvaluationStatusSignal class >> gtNormalOperationSignal [
	"Answer a Boolean indicating whether this signal is generated as part of normal operations.
	See {{gtMethod:BeaconSignal class>>gtNormalOperationSignal}} for a description"

	^ true.
]

{ #category : #accessing }
GtCoderIncomingEvaluationStatusSignal >> existingStatus [
	^ existingStatus
]

{ #category : #accessing }
GtCoderIncomingEvaluationStatusSignal >> existingStatus: anObject [
	existingStatus := anObject
]

{ #category : #accessing }
GtCoderIncomingEvaluationStatusSignal >> newStatus [
	^ newStatus
]

{ #category : #accessing }
GtCoderIncomingEvaluationStatusSignal >> newStatus: anObject [
	newStatus := anObject
]

{ #category : #printing }
GtCoderIncomingEvaluationStatusSignal >> printOneLineContentsOn: stream [
	stream print: viewModel identityHash.
	stream nextPutAll: ', '.
	existingStatus gtDisplayOn: stream.
	stream nextPutAll: ' -> '.
	newStatus gtDisplayOn: stream
]

{ #category : #accessing }
GtCoderIncomingEvaluationStatusSignal >> viewModel [
	^ viewModel
]

{ #category : #accessing }
GtCoderIncomingEvaluationStatusSignal >> viewModel: anObject [
	viewModel := anObject
]
