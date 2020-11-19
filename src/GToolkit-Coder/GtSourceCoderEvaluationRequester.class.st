Class {
	#name : #GtSourceCoderEvaluationRequester,
	#superclass : #GtSourceCoderRequester,
	#instVars : [
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #requester }
GtSourceCoderEvaluationRequester >> bindingOf: aSymbol [
	^ bindingStrategy isNil
		ifTrue: [ super bindingOf: aSymbol ]
		ifFalse: [ bindingStrategy bindingOf: aSymbol ]
]

{ #category : #accessing }
GtSourceCoderEvaluationRequester >> bindingStrategy [
	^ bindingStrategy
]

{ #category : #accessing }
GtSourceCoderEvaluationRequester >> bindingStrategy: anObject [
	bindingStrategy := anObject
]

{ #category : #requester }
GtSourceCoderEvaluationRequester >> correctFrom: aFromIndex to: aToIndex with: aString [
	self coder
		correctFrom: aFromIndex
		to: aToIndex
		with: aString
]

{ #category : #binding }
GtSourceCoderEvaluationRequester >> hasBindingOf: aSymbol [
	^ self bindingStrategy isNil
		ifTrue: [ super hasBindingOf: aSymbol ]
		ifFalse: [ bindingStrategy hasBindingOf: aSymbol ]

]

{ #category : #requester }
GtSourceCoderEvaluationRequester >> notify: message at: anIndex in: aString [	
	self coder
		notifyParseError: message
		at: anIndex
]

{ #category : #hack }
GtSourceCoderEvaluationRequester >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #'as yet unclassified' }
GtSourceCoderEvaluationRequester >> withInterval: aSourceInterval [
	
]
