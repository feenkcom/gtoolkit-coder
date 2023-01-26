Class {
	#name : #GtSingleObjectDiffSplit,
	#superclass : #GtDiffSplit,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtSingleObjectDiffSplit class >> on: aCollection at: anIndex [
	^ self new
		source: aCollection;
		startIndex: anIndex;
		yourself
]

{ #category : #accessing }
GtSingleObjectDiffSplit >> object [
	^ source at: startIndex
]

{ #category : #accessing }
GtSingleObjectDiffSplit >> stopIndex [
	^ startIndex
]
