Class {
	#name : #GtCoderCompiledMethodTextSource,
	#superclass : #GtCoderTextSource,
	#instVars : [
		'compiledMethod'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #accessing }
GtCoderCompiledMethodTextSource >> compiledMethod [

	^ compiledMethod
]

{ #category : #accessing }
GtCoderCompiledMethodTextSource >> compiledMethod: anObject [

	self critical: [ 
		compiledMethod := anObject.
		originalSourceText := nil ]
]

{ #category : #initialization }
GtCoderCompiledMethodTextSource >> computeOriginalSourceText [

	^ (compiledMethod isBigMethod
		ifTrue: [ (compiledMethod sourceCode first: 10000), '...' ]
		ifFalse: [ compiledMethod sourceCode ]) asRopedText
]
