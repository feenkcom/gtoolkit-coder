"
I am a {{gtClass:GtCoderEvaluationStatus}}.
I represent an evaluation status for a source code that was not executed.

"
Class {
	#name : #GtCoderNoEvaluationStatus,
	#superclass : #GtCoderEvaluationStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #printing }
GtCoderNoEvaluationStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'No evaluation'
]
