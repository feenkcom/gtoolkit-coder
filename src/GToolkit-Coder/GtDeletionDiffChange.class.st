Class {
	#name : #GtDeletionDiffChange,
	#superclass : #GtSourceDiffChange,
	#instVars : [
		'newIndex'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtDeletionDiffChange class >> highlightColor [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #accessing }
GtDeletionDiffChange >> applyAttributesToInput: aText [
	aText
		attribute: (BlTextHighlightAttribute paint: self highlightColor)
				beNotOverwritableByStyler
		from: self startIndex
		to: self stopIndex
]

{ #category : #accessing }
GtDeletionDiffChange >> deletedObjects [
	^ self objects
]

{ #category : #accessing }
GtDeletionDiffChange >> deletionChange [
	^ self
]

{ #category : #testing }
GtDeletionDiffChange >> isDeletion [
	^ true
]

{ #category : #accessing }
GtDeletionDiffChange >> newIndex [
	^ newIndex
]

{ #category : #accessing }
GtDeletionDiffChange >> newIndex: anInteger [
	newIndex := anInteger
]
