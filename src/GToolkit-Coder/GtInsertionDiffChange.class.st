Class {
	#name : #GtInsertionDiffChange,
	#superclass : #GtSourceDiffChange,
	#instVars : [
		'originalIndex'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #attributes }
GtInsertionDiffChange >> applyAttributesToOutput: aText [
	aText
		attribute: (BlTextHighlightAttribute paint: self highlightColor)
				beNotOverwritableByStyler
		from: self startIndex
		to: self stopIndex
]

{ #category : #accessing }
GtInsertionDiffChange >> highlightColorForTheme: aTheme [
	^ aTheme diffElement addedTextBackgroundColor
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

{ #category : #printing }
GtInsertionDiffChange >> jsonTypeName [
	^ 'insertion'
]

{ #category : #'as yet unclassified' }
GtInsertionDiffChange >> originalIndex [
	^ originalIndex
]

{ #category : #accessing }
GtInsertionDiffChange >> originalIndex: anInteger [
	originalIndex := anInteger
]
