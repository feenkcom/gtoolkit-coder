Class {
	#name : #GtInsertionDiffChange,
	#superclass : #GtSourceDiffChange,
	#instVars : [
		'originalIndex'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtInsertionDiffChange class >> highlightColor [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #accessing }
GtInsertionDiffChange >> applyAttributesToOutput: aText [
	aText
		attribute: (BlTextHighlightAttribute paint: self highlightColor)
				beNotOverwritableByStyler
		from: self startIndex
		to: self stopIndex.
]

{ #category : #accessing }
GtInsertionDiffChange >> insertedObjects [
	^ self objects
]

{ #category : #accessing }
GtInsertionDiffChange >> insertionChange [
	^ self
]

{ #category : #testing }
GtInsertionDiffChange >> isInsertion [
	^ true
]

{ #category : #'as yet unclassified' }
GtInsertionDiffChange >> originalIndex [
	^ originalIndex
]

{ #category : #accessing }
GtInsertionDiffChange >> originalIndex: anInteger [
	originalIndex := anInteger
]
