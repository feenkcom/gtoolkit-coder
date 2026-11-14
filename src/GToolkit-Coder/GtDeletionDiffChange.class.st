Class {
	#name : #GtDeletionDiffChange,
	#superclass : #GtSourceDiffChange,
	#instVars : [
		'newIndex'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #attributes }
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

{ #category : #accessing }
GtDeletionDiffChange >> highlightColorForTheme: aTheme [
	^ aTheme diffElement deletedTextBackgroundColor
]

{ #category : #testing }
GtDeletionDiffChange >> isDeletion [
	^ true
]

{ #category : #printing }
GtDeletionDiffChange >> jsonTypeName [
	^ 'deletion'
]

{ #category : #accessing }
GtDeletionDiffChange >> newIndex [
	^ newIndex
]

{ #category : #accessing }
GtDeletionDiffChange >> newIndex: anInteger [
	newIndex := anInteger
]
