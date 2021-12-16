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

	self critical: [ 
		futureBlock := aBlock.
		originalSourceTextPromise := nil ]
]

{ #category : #initialization }
GtCoderFutureTextSource >> originalSourceTextFuture [
	<return: #TAsyncFuture>

	^ futureBlock value map: [ :aString | aString asRopedText ]
]
