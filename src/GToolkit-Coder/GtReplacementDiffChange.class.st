Class {
	#name : #GtReplacementDiffChange,
	#superclass : #GtDiffChange,
	#instVars : [
		'insertionChange',
		'deletionChange'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtReplacementDiffChange class >> delete: aDeletionChange andInsert: anInsertionChange [
	^ self new
		deletionChange: aDeletionChange;
		insertionChange: anInsertionChange;
		yourself
]

{ #category : #formatting }
GtReplacementDiffChange >> applyAttributesToInput: aText [
	deletionChange applyAttributesToInput: aText
]

{ #category : #formatting }
GtReplacementDiffChange >> applyAttributesToOutput: aText [
	insertionChange applyAttributesToOutput: aText
]

{ #category : #accessing }
GtReplacementDiffChange >> deletedObjects [
	^ deletionChange objects
]

{ #category : #accessing }
GtReplacementDiffChange >> deletionChange [
	^ deletionChange
]

{ #category : #accessing }
GtReplacementDiffChange >> deletionChange: aDeletionChange [
	deletionChange := aDeletionChange
]

{ #category : #accessing }
GtReplacementDiffChange >> insertedObjects [
	^ insertionChange objects
]

{ #category : #accessing }
GtReplacementDiffChange >> insertionChange [
	^ insertionChange
]

{ #category : #accessing }
GtReplacementDiffChange >> insertionChange: anInsertionChange [
	insertionChange := anInsertionChange
]

{ #category : #testing }
GtReplacementDiffChange >> isReplacement [
	^ true
]

{ #category : #accessing }
GtReplacementDiffChange >> range [
	^ self deletionChange range , ', ' , self insertionChange range
]
