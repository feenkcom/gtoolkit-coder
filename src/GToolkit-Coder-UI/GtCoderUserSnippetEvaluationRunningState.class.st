Class {
	#name : #GtCoderUserSnippetEvaluationRunningState,
	#superclass : #GtCoderUserSnippetEvaluationState,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : 'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #printing }
GtCoderUserSnippetEvaluationRunningState >> gtDisplayOn: stream [
	stream nextPutAll: 'Running snippet'
]
