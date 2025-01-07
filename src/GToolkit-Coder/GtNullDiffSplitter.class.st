Class {
	#name : #GtNullDiffSplitter,
	#superclass : #GtDiffSplitter,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'as yet unclassified' }
GtNullDiffSplitter >> descriptionString [
	^ 'do not split'
]

{ #category : #actions }
GtNullDiffSplitter >> split: aCollection into: aGtDiffSplits [
	1
		to: aCollection size
		do: [ :i | aGtDiffSplits addSplit: (GtSingleObjectDiffSplit on: aCollection at: i) ]
]
