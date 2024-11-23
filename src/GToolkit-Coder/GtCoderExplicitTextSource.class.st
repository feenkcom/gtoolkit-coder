Class {
	#name : #GtCoderExplicitTextSource,
	#superclass : #GtCoderTextSource,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #initialization }
GtCoderExplicitTextSource >> computeOriginalSourceText [
	^ text copy
]

{ #category : #accessing }
GtCoderExplicitTextSource >> text [
	^ text
]

{ #category : #accessing }
GtCoderExplicitTextSource >> text: aStringOrText [

	self critical: [ 
		text := aStringOrText asRopedText.
		originalSourceText := nil ]
]
