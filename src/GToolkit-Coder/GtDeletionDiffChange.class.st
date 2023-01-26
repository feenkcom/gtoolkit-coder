Class {
	#name : #GtDeletionDiffChange,
	#superclass : #GtSourceDiffChange,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtDeletionDiffChange >> deletedObjects [
	^ self objects
]

{ #category : #accessing }
GtDeletionDiffChange >> deletionChange [
	^ self
]

{ #category : #accessing }
GtDeletionDiffChange >> gtObjectsText [
	^ self objects asString asRopedText glamorousRegularFont
		highlight: BrGlamorousColors errorBackgroundColor
]

{ #category : #accessing }
GtDeletionDiffChange >> highlightColor [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #testing }
GtDeletionDiffChange >> isDeletion [
	^ true
]
