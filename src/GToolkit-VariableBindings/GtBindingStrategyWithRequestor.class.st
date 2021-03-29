Class {
	#name : #GtBindingStrategyWithRequestor,
	#superclass : #Object,
	#instVars : [
		'requestor',
		'bindingStrategy'
	],
	#category : #'GToolkit-VariableBindings-Commands'
}

{ #category : #binding }
GtBindingStrategyWithRequestor >> bindingOf: aSymbol [
	<return: #LiteralVariable or: nil>
	^ self bindingStrategy bindingOf: aSymbol
]

{ #category : #accessing }
GtBindingStrategyWithRequestor >> bindingStrategy [
	<return: #GtBindingStrategy>
	^ bindingStrategy
]

{ #category : #accessing }
GtBindingStrategyWithRequestor >> bindingStrategy: aGtBindingStrategy [
	self 
		assert: [ aGtBindingStrategy notNil ] 
		description: [ 'Binding strategy must be non-nil' ].
	bindingStrategy := aGtBindingStrategy
]

{ #category : #initialization }
GtBindingStrategyWithRequestor >> initialize [
	super initialize.
	bindingStrategy := GtSnippetBindingStrategy new.
	requestor := nil.
]

{ #category : #accessing }
GtBindingStrategyWithRequestor >> requestor [
	^ requestor
]

{ #category : #accessing }
GtBindingStrategyWithRequestor >> requestor: anObject [
	requestor := anObject
]

{ #category : #accessing }
GtBindingStrategyWithRequestor >> selection [
	<return: #BlSelection or: #String>
	^ self requestor 
		ifNotNil: [ :aRequestor | 
			(aRequestor respondsTo: #selection)
				ifTrue: [ aRequestor selection ]
				ifFalse: [ '' ] ] 
		ifNil: [ '' ]
]
