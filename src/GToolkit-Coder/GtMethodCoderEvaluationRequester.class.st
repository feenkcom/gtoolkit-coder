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
	super correctFrom: fromIndex to: toIndex with: aString.
	selectionInterval := selectionInterval first to: selectionInterval last + aString size - (toIndex - fromIndex + 1).
	coder sourceEditor selecter
		from: selectionInterval first to: selectionInterval last;
		select
]

{ #category : #private }
GtMethodCoderEvaluationRequester >> offset [
	^ selectionInterval first negated + 2
]

{ #category : #requester }
GtMethodCoderEvaluationRequester >> selection [
	^ (coder sourceEditor text from: selectionInterval first to: selectionInterval last) asString
]

{ #category : #requester }
GtMethodCoderEvaluationRequester >> text [
	^ self selection
]
