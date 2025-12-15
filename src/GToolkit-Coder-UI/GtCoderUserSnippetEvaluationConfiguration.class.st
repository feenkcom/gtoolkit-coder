Class {
	#name : #GtCoderUserSnippetEvaluationConfiguration,
	#superclass : #Object,
	#category : 'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtCoderUserSnippetEvaluationConfiguration class >> handledErrors [
	^ GtCoderEvaluationUnhandledError , Halt, Warning
]
