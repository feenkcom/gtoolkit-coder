Class {
	#name : #GtCoderNotUserSnippetState,
	#superclass : #GtCoderUserSnippetEvaluationState,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : 'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #printing }
GtCoderNotUserSnippetState >> gtDisplayOn: stream [
	stream nextPutAll: 'No user snippet'
]

{ #category : #accessing }
GtCoderNotUserSnippetState >> isUserSnippet [
	^ false
]
