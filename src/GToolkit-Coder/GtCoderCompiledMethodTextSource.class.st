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

	compiledMethod := anObject
]

{ #category : #initialization }
GtCoderCompiledMethodTextSource >> originalSourceTextFuture [
	<return: #TAsyncFuture>

	^ [ compiledMethod sourceCode asRopedText ] asAsyncFuture
]
