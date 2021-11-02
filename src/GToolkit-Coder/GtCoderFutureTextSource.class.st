Class {
	#name : #GtCoderFutureTextSource,
	#superclass : #GtCoderTextSource,
	#instVars : [
		'futureBlock'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #accessing }
GtCoderFutureTextSource >> future: aBlock [
	futureBlock := aBlock
]

{ #category : #initialization }
GtCoderFutureTextSource >> originalSourceTextFuture [
	<return: #TAsyncFuture>

	^ futureBlock value map: [ :aString | aString asRopedText ]
]
