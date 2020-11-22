Class {
	#name : #GtSourceCoderIntervalEvaluationRequester,
	#superclass : #GtSourceCoderEvaluationRequester,
	#instVars : [
		'source',
		'interval'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtSourceCoderIntervalEvaluationRequester class >> on: aCoder editor: aBrTextEditor [
	^ self new
		coder: aCoder editor: aBrTextEditor;
		yourself
]

{ #category : #requester }
GtSourceCoderIntervalEvaluationRequester >> correctFrom: fromIndex to: toIndex with: aString [
	super correctFrom: interval first + fromIndex - 1 to: interval first + toIndex - 1 with: aString.
	interval := interval first to: interval last + aString size - (toIndex - fromIndex + 1)
]

{ #category : #initialization }
GtSourceCoderIntervalEvaluationRequester >> initialize [
	super initialize.
	
	interval := 1 to: 0
]

{ #category : #accessing }
GtSourceCoderIntervalEvaluationRequester >> interval [
	^ interval
]

{ #category : #accessing }
GtSourceCoderIntervalEvaluationRequester >> interval: anObject [
	interval := anObject
]

{ #category : #requester }
GtSourceCoderIntervalEvaluationRequester >> notify: message at: anIndex in: aString [
	| location selectionStart |
	selectionStart := interval isNil
		ifTrue: [ 1 ]
		ifFalse: [ interval first ].
	location := anIndex + selectionStart - 2.
	^ super notify: message at: (location max: 1) in: aString
]

{ #category : #requester }
GtSourceCoderIntervalEvaluationRequester >> selection [
	<return: #String>

	^ source
]

{ #category : #accessing }
GtSourceCoderIntervalEvaluationRequester >> source: aString [
	source := aString
]

{ #category : #requester }
GtSourceCoderIntervalEvaluationRequester >> text [
	^ self selection
]
