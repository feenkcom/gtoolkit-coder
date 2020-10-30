Class {
	#name : #GtSyncScrollRanges,
	#superclass : #Object,
	#instVars : [
		'ranges'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #'instance creation' }
GtSyncScrollRanges class >> createFromDiff: aDiffBuilder [
	| syncScroll |
	syncScroll := self new.
	aDiffBuilder
		patchSequenceDoIfMatch: [ :line | syncScroll advanceBoth ]
		ifInsert: [ :line | syncScroll advanceRight ]
		ifRemove: [ :line | syncScroll advanceLeft ].
	syncScroll mergeDifferences.
	^ syncScroll
]

{ #category : #examples }
GtSyncScrollRanges class >> example [
	<gtExample>
	^ self createFromDiff: self exampleDiff
]

{ #category : #examples }
GtSyncScrollRanges class >> exampleDiff [
	<gtExample>
	^ TextDiffBuilder from: self originalString to: self newString
]

{ #category : #examples }
GtSyncScrollRanges class >> newString [
	<gtExample>
	^ '1
4
5
6
7
8
9'
]

{ #category : #examples }
GtSyncScrollRanges class >> originalString [
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

{ #category : #'private-creation' }
GtSyncScrollRanges >> advanceBoth [
	ranges last advanceBoth ifNotNil: [ :range | ranges add: range ]
]

{ #category : #'private-creation' }
GtSyncScrollRanges >> advanceLeft [
	ranges last advanceLeft ifNotNil: [ :range | ranges add: range ]
]

{ #category : #'private-creation' }
GtSyncScrollRanges >> advanceRight [
	ranges last advanceRight ifNotNil: [ :range | ranges add: range ]
]

{ #category : #'initialize-release' }
GtSyncScrollRanges >> initialize [
	super initialize.
	ranges := OrderedCollection with: GtSyncScrollRange new
]

{ #category : #accessing }
GtSyncScrollRanges >> leftLineFor: rightIndex [
	| range |
	range := ranges
		detect: [ :each | rightIndex between: each rightFirst and: each rightLast ]
		ifNone: [ ^ 0 ].
	range rightSize = 0
		ifTrue: [ ^ 0 ].
	^ ((rightIndex asFloat - range rightFirst) / range rightSize
		* range leftSize + range leftFirst) rounded 
]

{ #category : #'private-creation' }
GtSyncScrollRanges >> mergeDifferences [
	| index current previous |
	index := ranges size.
	current := ranges last.
	[ index > 1 ]
		whileTrue: [ previous := ranges at: index - 1.
			(current isDifference and: [ previous isDifference ])
				ifTrue: [ previous mergeWith: current.
					ranges removeAtIndex: index ].
			index := index - 1.
			current := previous ]
]

{ #category : #accessing }
GtSyncScrollRanges >> rangesForLeft: leftInterval andRight: rightInterval [
	^ ranges
		select: [ :each | each overlapsLeft: leftInterval orRight: rightInterval ]
]

{ #category : #accessing }
GtSyncScrollRanges >> rightLineFor: leftIndex [
	| range |
	range := ranges
		detect: [ :each | leftIndex between: each leftFirst and: each leftLast ]
		ifNone: [ ^ 0 ].
	range leftSize = 0
		ifTrue: [ ^ 0 ].
	^ ((leftIndex asFloat - range leftFirst) / range leftSize
		* range rightSize + range rightFirst) rounded 
]
