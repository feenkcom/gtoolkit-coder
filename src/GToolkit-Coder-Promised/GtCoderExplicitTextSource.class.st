Class {
	#name : #GtCoderExplicitTextSource,
	#superclass : #GtCoderTextSource,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-Promised'
}

{ #category : #'api - accessing' }
GtCoderExplicitTextSource >> asAstCacheKey [
	^ text
]

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
