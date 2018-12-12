Class {
	#name : #GtMethodCoderEvaluationRequester,
	#superclass : #GtMethodCoderRequester,
	#instVars : [
		'selectionInterval'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtMethodCoderEvaluationRequester >> coder: aCoder [
	super coder: aCoder.
	aCoder sourceEditor selection do: [ :each | selectionInterval := each from + 1 to: each to ]
]

{ #category : #requester }
GtMethodCoderEvaluationRequester >> correctFrom: fromIndex to: toIndex with: aString [
	super correctFrom: selectionInterval first + fromIndex - 1 to: selectionInterval first + toIndex - 1 with: aString.
	selectionInterval := selectionInterval first to: selectionInterval last + aString size - (toIndex - fromIndex + 1).
	coder sourceEditor selecter
		from: selectionInterval first to: selectionInterval last;
		select
]

{ #category : #requester }
GtMethodCoderEvaluationRequester >> notify: message at: anIndex in: aString [
	| location |
	location := anIndex + selectionInterval first - 2.
	^ super notify: message at: (location max: 1) in: aString
]

{ #category : #requester }
GtMethodCoderEvaluationRequester >> selection [
	^ (coder sourceEditor text from: selectionInterval first to: selectionInterval last) asString
]

{ #category : #requester }
GtMethodCoderEvaluationRequester >> text [
	^ self selection
]
