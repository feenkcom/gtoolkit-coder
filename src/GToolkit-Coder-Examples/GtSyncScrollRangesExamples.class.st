Class {
	#name : #GtSyncScrollRangesExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #examples }
GtSyncScrollRangesExamples >> example [
	<gtExample>
	^ GtSyncScrollRanges createFromChange: self exampleDiff
]

{ #category : #examples }
GtSyncScrollRangesExamples >> exampleDiff [
	<gtExample>
	^ GtDiffBuilder
		computeDifferencesFrom: self originalString
		to: self newString
		using: GtCharacterGroupDiffSplitter words
]

{ #category : #examples }
GtSyncScrollRangesExamples >> multilineCode [
	<gtExample>
	| change ranges |
	change := GtDiffBuilderExamples new tokenChanges.
	ranges := GtSyncScrollRanges createFromChange: change.
	self assert: ranges ranges size equals: 1.
	^ ranges
]

{ #category : #private }
GtSyncScrollRangesExamples >> newString [
	<gtExample>
	^ '1
4
5
6
7
8
9'
]

{ #category : #private }
GtSyncScrollRangesExamples >> originalString [
	<gtExample>
	^ '1
2
3
5
6
7
9
10'
]

{ #category : #examples }
GtSyncScrollRangesExamples >> reversedMultilineCode [
	<gtExample>
	| change ranges |
	change := GtDiffBuilderExamples new reversedTokenChanges.
	ranges := GtSyncScrollRanges createFromChange: change.
	self assert: ranges ranges size equals: 1.
	^ ranges
]

{ #category : #examples }
GtSyncScrollRangesExamples >> textDiffExample [
	<gtExample>
	^ GtSyncScrollRanges
		createFromDiff: (TextDiffBuilder from: self originalString to: self newString)
]
