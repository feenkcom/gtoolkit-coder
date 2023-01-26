Class {
	#name : #GtRangeDiffSplit,
	#superclass : #GtDiffSplit,
	#instVars : [
		'stopIndex',
		'object'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtRangeDiffSplit class >> on: aCollection from: startIndex to: stopIndex [
	^ self new
		source: aCollection;
		startIndex: startIndex;
		stopIndex: stopIndex;
		yourself
]

{ #category : #accessing }
GtRangeDiffSplit >> object [
	^ object ifNil: [ object := source copyFrom: startIndex to: stopIndex ]
]

{ #category : #accessing }
GtRangeDiffSplit >> stopIndex [
	^ stopIndex
]

{ #category : #accessing }
GtRangeDiffSplit >> stopIndex: anInteger [
	stopIndex := anInteger
]
