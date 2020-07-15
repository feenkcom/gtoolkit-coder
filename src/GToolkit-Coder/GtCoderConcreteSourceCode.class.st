"
I represent a concrete source code that was provided as a string
"
Class {
	#name : #GtCoderConcreteSourceCode,
	#superclass : #GtCoderSourceCode,
	#instVars : [
		'source'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #initialization }
GtCoderConcreteSourceCode >> buildCollapsedText [
	<return: #BlText>

	^ (self sourceString linesDo: [ :eachLine | eachLine trimmed ifNotEmpty: [ :aNonEmptyLine | ^ aNonEmptyLine ] ]) asRopedText
]

{ #category : #initialization }
GtCoderConcreteSourceCode >> buildSourceText [
	<return: #BlText>

	^ source asRopedText
]

{ #category : #'api - testing' }
GtCoderConcreteSourceCode >> isModified [
	^ self source ~= self sourceString
]

{ #category : #accessing }
GtCoderConcreteSourceCode >> source [
	^ source
]

{ #category : #accessing }
GtCoderConcreteSourceCode >> source: anObject [
	source := anObject
]
