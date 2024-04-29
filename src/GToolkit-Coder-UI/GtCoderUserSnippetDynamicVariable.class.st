Class {
	#name : #GtCoderUserSnippetDynamicVariable,
	#superclass : #DynamicVariable,
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtCoderUserSnippetDynamicVariable class >> value: aSnippetEvaluationState [
	^ self soleInstance value: aSnippetEvaluationState
]

{ #category : #accessing }
GtCoderUserSnippetDynamicVariable >> default [
	^ GtCoderUserNotUserSnippetState default
]

{ #category : #accessing }
GtCoderUserSnippetDynamicVariable >> value: aSnippetEvaluationState [
	| activeProcess |
	activeProcess := Processor activeProcess.
	^ activeProcess psValueAt: index put: aSnippetEvaluationState
]
