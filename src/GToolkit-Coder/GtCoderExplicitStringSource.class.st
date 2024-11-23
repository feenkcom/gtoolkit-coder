Class {
	#name : #GtCoderExplicitStringSource,
	#superclass : #GtCoderTextSource,
	#instVars : [
		'source'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #initialization }
GtCoderExplicitStringSource >> computeOriginalSourceText [
	^ source asRopedText
]

{ #category : #accessing }
GtCoderExplicitStringSource >> source [

	^ source
]

{ #category : #accessing }
GtCoderExplicitStringSource >> source: anObject [

	self critical: [ 
		source := anObject.
		originalSourceText := nil ]
]
