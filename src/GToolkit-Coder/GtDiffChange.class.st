Class {
	#name : #GtDiffChange,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtDiffChange >> deletedObjects [
	^ nil
]

{ #category : #accessing }
GtDiffChange >> deletionChange [
	^ nil
]

{ #category : #accessing }
GtDiffChange >> gtObjectsText [
	^ '' asRopedText
]

{ #category : #accessing }
GtDiffChange >> insertedObjects [
	^ nil
]

{ #category : #accessing }
GtDiffChange >> insertionChange [
	^ nil
]

{ #category : #testing }
GtDiffChange >> isDeletion [
	^ false
]

{ #category : #testing }
GtDiffChange >> isInsertion [
	^ false
]

{ #category : #testing }
GtDiffChange >> isReplacement [
	^ false
]
