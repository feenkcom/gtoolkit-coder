"
I represent an explicit source code that was provided as a string
"
Class {
	#name : #GtCoderExplicitSourceCode,
	#superclass : #GtCoderSourceCode,
	#instVars : [
		'source'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - accessing' }
GtCoderExplicitSourceCode >> asAstCacheKey [
	^ source
]

{ #category : #initialization }
GtCoderExplicitSourceCode >> buildCollapsedText [
	<return: #BlText>

	^ (self sourceString linesDo: [ :eachLine | eachLine trimmed ifNotEmpty: [ :aNonEmptyLine | ^ aNonEmptyLine ] ]) asRopedText
]

{ #category : #initialization }
GtCoderExplicitSourceCode >> buildSourceText [
	<return: #BlText>

	^ source asRopedText
]

{ #category : #'api - testing' }
GtCoderExplicitSourceCode >> isModified [
	^ self source ~= self sourceString
]

{ #category : #accessing }
GtCoderExplicitSourceCode >> source [
	^ source
]

{ #category : #accessing }
GtCoderExplicitSourceCode >> source: aString [
	source := aString
]
