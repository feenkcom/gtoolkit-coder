Class {
	#name : #GtDeletionDiffChange,
	#superclass : #GtSourceDiffChange,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtDeletionDiffChange >> applyAttributesToInput: aText [
	(aText from: self startIndex to: self stopIndex) highlight: self highlightColor
]

{ #category : #accessing }
GtDeletionDiffChange >> deletedObjects [
	^ self objects
]

{ #category : #accessing }
GtDeletionDiffChange >> deletionChange [
	^ self
]

{ #category : #accessing }
GtDeletionDiffChange >> highlightColor [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #testing }
GtDeletionDiffChange >> isDeletion [
	^ true
]
