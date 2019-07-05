Class {
	#name : #GtSourceCoderEvaluationRequester,
	#superclass : #GtSourceCoderRequester,
	#instVars : [
		'selectionInterval',
		'source'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtSourceCoderEvaluationRequester >> coder: aCoder [
	super coder: aCoder.
	selectionInterval := aCoder selectedSourceInterval
]

{ #category : #requester }
GtSourceCoderEvaluationRequester >> correctFrom: fromIndex to: toIndex with: aString [
	super correctFrom: selectionInterval first + fromIndex - 1 to: selectionInterval first + toIndex - 1 with: aString.
	selectionInterval := selectionInterval first to: selectionInterval last + aString size - (toIndex - fromIndex + 1).
	coder sourceEditor selecter
		from: selectionInterval first to: selectionInterval last;
		select
]

{ #category : #requester }
GtSourceCoderEvaluationRequester >> notify: message at: anIndex in: aString [
	| location selectionStart |
	selectionStart := selectionInterval ifNil: [ 1 ].
	location := anIndex + selectionStart - 2.
	^ super notify: message at: (location max: 1) in: aString
]

{ #category : #requester }
GtSourceCoderEvaluationRequester >> selection [
	^ source
]

{ #category : #accessing }
GtSourceCoderEvaluationRequester >> source: aString [
	source := aString
]

{ #category : #requester }
GtSourceCoderEvaluationRequester >> text [
	^ self selection
]
