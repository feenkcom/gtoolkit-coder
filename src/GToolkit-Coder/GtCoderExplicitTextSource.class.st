Class {
	#name : #GtCoderExplicitTextSource,
	#superclass : #GtCoderTextSource,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #initialization }
GtCoderExplicitTextSource >> originalSourceTextFuture [
	<return: #TAsyncFuture>

	^ [ text copy ] asAsyncFuture
]

{ #category : #accessing }
GtCoderExplicitTextSource >> text [
	^ text
]

{ #category : #accessing }
GtCoderExplicitTextSource >> text: aStringOrText [
	text := aStringOrText asRopedText
]
