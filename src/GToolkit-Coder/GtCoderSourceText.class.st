Class {
	#name : #GtCoderSourceText,
	#superclass : #Object,
	#instVars : [
		'text',
		'epoch'
	],
	#category : #'GToolkit-Coder-Coders - Source Text'
}

{ #category : #converting }
GtCoderSourceText >> asSourceString [
	<return: #GtCoderSourceString>

	^ GtCoderSourceString new
		string: text asString;
		epoch: epoch
]

{ #category : #accessing }
GtCoderSourceText >> epoch [
	^ epoch
]

{ #category : #initialization }
GtCoderSourceText >> initialize [
	super initialize.
	
	epoch := GtCoderSourceEpoch new
]

{ #category : #accessing }
GtCoderSourceText >> text [

	^ text
]

{ #category : #accessing }
GtCoderSourceText >> text: aBlText [
	self
		assert: [ text isNil ]
		description: [ 'Source text can not be modified' ].

	text := aBlText.
	epoch := epoch nextEpoch
]
