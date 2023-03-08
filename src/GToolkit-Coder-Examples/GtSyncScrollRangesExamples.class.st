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

{ #category : #accessing }
GtSyncScrollRangesExamples >> multipleChanges [
	<gtExample>
	| diff ranges |
	diff := GtDiffBuilderExamples new multipleChanges.
	ranges := GtSyncScrollRanges createFromChange: diff.
	ranges ranges
		inject: {0.
				0}
		into: [ :last :each | 
			self assert: last first equals: each leftFirst.
			self assert: last last equals: each rightFirst.
			{each leftLast.
				each rightLast} ].
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

{ #category : #accessing }
GtSyncScrollRangesExamples >> nextPreviousLeftChange [
	<gtExample>
	| diff ranges |
	diff := GtDiffBuilderExamples new deletionsInMiddle.
	ranges := GtSyncScrollRanges createFromChange: diff.
	self validateNextLeftChangeIn: ranges equals: #(1 5 5).
	self validatePreviousLeftChangeIn: ranges equals: #(6 5 5).
	^ ranges
]

{ #category : #accessing }
GtSyncScrollRangesExamples >> nextPreviousMultipleChanges [
	<gtExample>
	| ranges |
	ranges := self multipleChanges.
	self validateNextLeftChangeIn: ranges equals: #(1 2 4).
	self validateNextRightChangeIn: ranges equals: #(1 2 5).
	^ ranges
]

{ #category : #accessing }
GtSyncScrollRangesExamples >> nextPreviousRightChange [
	<gtExample>
	| diff ranges |
	diff := GtDiffBuilderExamples new insertionsInMiddle.
	ranges := GtSyncScrollRanges createFromChange: diff.
	self validateNextRightChangeIn: ranges equals: #(1 5 5).
	self validatePreviousRightChangeIn: ranges equals: #(6 5 5).
	^ ranges
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

{ #category : #examples }
GtSyncScrollRangesExamples >> textDiffNextChange [
	<gtExample>
	| ranges |
	ranges := self textDiffExample.
	self validateNextLeftChangeIn: ranges equals: #(1 2 7 8 2).
	self validatePreviousLeftChangeIn: ranges equals: #(8 7 2 8).
	self validateNextRightChangeIn: ranges equals: #(1 2 6 8 2).
	self validatePreviousRightChangeIn: ranges equals: #(8 8 6 2 8).
	^ ranges
]

{ #category : #accessing }
GtSyncScrollRangesExamples >> validateNextLeftChangeIn: ranges equals: stops [
	| stream |
	stream := ReadStream on: stops.
	ranges selectRange: (ranges rangeForLeft: stream next).
	[ stream atEnd ]
		whileFalse: [ self assert: ranges selectNext leftFirst + 1 equals: stream next ]
]

{ #category : #accessing }
GtSyncScrollRangesExamples >> validateNextRightChangeIn: ranges equals: stops [
	| stream |
	stream := ReadStream on: stops.
	ranges selectRange: (ranges rangeForRight: stream next).
	[ stream atEnd ]
		whileFalse: [ self assert: ranges selectNext rightFirst + 1 equals: stream next ]
]

{ #category : #accessing }
GtSyncScrollRangesExamples >> validatePreviousLeftChangeIn: ranges equals: stops [
	| stream |
	stream := ReadStream on: stops.
	ranges selectRange: (ranges rangeForLeft: stream next).
	[ stream atEnd ]
		whileFalse: [ self assert: ranges selectPrevious leftFirst + 1 equals: stream next ]
]

{ #category : #accessing }
GtSyncScrollRangesExamples >> validatePreviousRightChangeIn: ranges equals: stops [
	| stream |
	stream := ReadStream on: stops.
	ranges selectRange: (ranges rangeForRight: stream next).
	[ stream atEnd ]
		whileFalse: [ self assert: ranges selectPrevious rightFirst + 1 equals: stream next ]
]
