Class {
	#name : #GtCoderIncomingEvaluationStatusSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'viewModel',
		'existingStatus',
		'newStatus'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

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
