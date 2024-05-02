Class {
	#name : #GtCoderEvaluationStatusChangedSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'viewModel',
		'oldStatus',
		'newStatus'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderEvaluationStatusChangedSignal >> newStatus [
	^ newStatus
]

{ #category : #accessing }
GtCoderEvaluationStatusChangedSignal >> newStatus: anObject [
	newStatus := anObject
]

{ #category : #accessing }
GtCoderEvaluationStatusChangedSignal >> oldStatus [
	^ oldStatus
]

{ #category : #accessing }
GtCoderEvaluationStatusChangedSignal >> oldStatus: anObject [
	oldStatus := anObject
]

{ #category : #printing }
GtCoderEvaluationStatusChangedSignal >> printOneLineContentsOn: stream [
	stream print: viewModel identityHash.
	stream nextPutAll: ', '.
	oldStatus gtDisplayOn: stream.
	stream nextPutAll: ' -> '.
	newStatus gtDisplayOn: stream
]

{ #category : #accessing }
GtCoderEvaluationStatusChangedSignal >> viewModel [
	^ viewModel
]

{ #category : #accessing }
GtCoderEvaluationStatusChangedSignal >> viewModel: anObject [
	viewModel := anObject
]
