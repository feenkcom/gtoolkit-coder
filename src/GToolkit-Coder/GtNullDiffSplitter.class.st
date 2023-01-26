Class {
	#name : #GtNullDiffSplitter,
	#superclass : #GtDiffSplitter,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #actions }
GtNullDiffSplitter >> split: aCollection into: aGtDiffSplits [
	1
		to: aCollection size
		do: [ :i | aGtDiffSplits addSplit: (GtSingleObjectDiffSplit on: aCollection at: i) ]
]
