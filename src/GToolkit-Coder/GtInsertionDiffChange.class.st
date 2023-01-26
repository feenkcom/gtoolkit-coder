Class {
	#name : #GtInsertionDiffChange,
	#superclass : #GtSourceDiffChange,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtInsertionDiffChange >> gtObjectsText [
	^ self objects asString asRopedText glamorousRegularFont
		highlight: BrGlamorousColors successBackgroundColor
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
