Class {
	#name : #GtCoderUserSnippetEvaluationExceptionState,
	#superclass : #GtCoderUserSnippetEvaluationState,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #printing }
GtCoderUserSnippetEvaluationExceptionState >> gtDisplayOn: stream [
	stream nextPutAll: 'Snippet with exception'
]
