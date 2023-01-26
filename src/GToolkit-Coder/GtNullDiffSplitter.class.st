Class {
	#name : #GtNullDiffSplitter,
	#superclass : #GtDiffSplitter,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #actions }
GtNullDiffSplitter >> split: aCollection [
	^ (1 to: aCollection size)
		collect: [ :i | GtSingleObjectDiffSplit on: aCollection at: i ]
]
