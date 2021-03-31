Class {
	#name : #GtContextHighlightingBindingStrategy,
	#superclass : #GtHighlightingBindingStrategy,
	#instVars : [
		'context'
	],
	#category : #'GToolkit-VariableBindings-Core'
}

{ #category : #binding }
GtContextHighlightingBindingStrategy >> bindingOf: aSymbol [
	| value |
	(super bindingOf: aSymbol) ifNotNil: [ :aBinding | aBinding ].
	(self hasBindingOf: aSymbol) ifFalse: [ ^ nil ].
	
	value := [ (context tempNamed: aSymbol) ] on: Error do: [ nil ].
	^ WorkspaceVariable key: aSymbol value: value
]

{ #category : #accessing }
GtContextHighlightingBindingStrategy >> context: aContext [
	context := aContext
]

{ #category : #binding }
GtContextHighlightingBindingStrategy >> hasBindingOf: aSymbol [
	^ (super hasBindingOf: aSymbol) or: [ 
			context hasTemporaryVariableNamed: aSymbol ]
]
