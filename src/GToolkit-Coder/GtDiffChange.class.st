Class {
	#name : #GtDiffChange,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #formatting }
GtDiffChange >> applyAttributesToInput: aText [
]

{ #category : #formatting }
GtDiffChange >> applyAttributesToOutput: aText [
]

{ #category : #accessing }
GtDiffChange >> deletedObjects [
	^ nil
]

{ #category : #accessing }
GtDiffChange >> deletionChange [
	^ nil
]

{ #category : #iterating }
GtDiffChange >> deletionChangesDo: aBlock [
	self deletionChange ifNotNil: aBlock
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

{ #category : #iterating }
GtDiffChange >> insertionChangesDo: aBlock [
	self insertionChange ifNotNil: aBlock
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
