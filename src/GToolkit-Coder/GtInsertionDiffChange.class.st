Class {
	#name : #GtInsertionDiffChange,
	#superclass : #GtSourceDiffChange,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtInsertionDiffChange >> applyAttributesToOutput: aText [
	(aText from: self startIndex to: self stopIndex) highlight: self highlightColor
]

{ #category : #accessing }
GtInsertionDiffChange >> highlightColor [
	^ BrGlamorousColors successBackgroundColor
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
