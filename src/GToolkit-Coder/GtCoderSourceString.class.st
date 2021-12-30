Class {
	#name : #GtCoderSourceString,
	#superclass : #Object,
	#instVars : [
		'sourceText',
		'string',
		'epoch'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #accessing }
GtCoderSourceString >> epoch [

	^ epoch
]

{ #category : #accessing }
GtCoderSourceString >> epoch: anObject [
	epoch := anObject
]

{ #category : #accessing }
GtCoderSourceString >> sourceText [
	<return: #GtCoderSourceText>

	^ sourceText
]

{ #category : #accessing }
GtCoderSourceString >> sourceText: aGtCoderSourceText [

	sourceText := aGtCoderSourceText
]

{ #category : #accessing }
GtCoderSourceString >> string [

	^ string
]

{ #category : #accessing }
GtCoderSourceString >> string: anObject [

	string := anObject
]
