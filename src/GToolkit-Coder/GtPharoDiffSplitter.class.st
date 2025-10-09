Class {
	#name : #GtPharoDiffSplitter,
	#superclass : #GtSmaCCDiffSplitter,
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'as yet unclassified' }
GtPharoDiffSplitter >> createCommentSplitFrom: start to: stop into: aGtDiffSplits [
	GtCharacterGroupDiffSplitter words
		split: string
		from: start
		to: stop
		into: aGtDiffSplits
]

{ #category : #'as yet unclassified' }
GtPharoDiffSplitter >> createTokenSplitFrom: aToken into: aGtDiffSplits [
	aToken value first = $'
		ifFalse: [ ^ super createTokenSplitFrom: aToken into: aGtDiffSplits ].
	GtCharacterGroupDiffSplitter words
		split: string
		from: aToken startPosition
		to: aToken stopPosition
		into: aGtDiffSplits
]
