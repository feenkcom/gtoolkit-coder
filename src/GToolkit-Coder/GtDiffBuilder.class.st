Class {
	#name : #GtDiffBuilder,
	#superclass : #Object,
	#instVars : [
		'splitter',
		'from',
		'to',
		'fromSplits',
		'toSplits',
		'fromStart',
		'fromEnd',
		'toStart',
		'toEnd',
		'differences'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #computing }
GtDiffBuilder class >> computeDifferencesFrom: fromCollection to: toCollection using: aGtDiffSplitter [
	| builder |
	builder := self new.
	builder from: fromCollection.
	builder to: toCollection.
	builder splitter: aGtDiffSplitter.
	^ builder computeDifferences
]

{ #category : #private }
GtDiffBuilder >> addDeletions [
	| startIndex stopIndex |
	startIndex := fromStart > 1
			ifTrue: [ (fromSplits at: fromStart) startIndex ]
			ifFalse: [ 1 ].
	stopIndex := fromEnd < from size
			ifTrue: [ (fromSplits at: fromEnd) stopIndex ]
			ifFalse: [ from size ].
	differences
		add: (GtDeletionDiffChange
				on: from
				from: startIndex
				to: stopIndex)
]

{ #category : #private }
GtDiffBuilder >> addInsertions [
	| startIndex stopIndex |
	startIndex := toStart > 1
			ifTrue: [ (toSplits at: toStart) startIndex ]
			ifFalse: [ 1 ].
	stopIndex := toEnd < to size
			ifTrue: [ (toSplits at: toEnd) stopIndex ]
			ifFalse: [ to size ].
	differences
		add: (GtInsertionDiffChange
				on: to
				from: startIndex
				to: stopIndex)
]

{ #category : #private }
GtDiffBuilder >> addInsertionsAndDeletionsIgnoring: commonElements [
	[ fromStart <= fromEnd or: [ toStart <= toEnd ] ]
		whileTrue: [ | deletion insertion start end split |
			[ fromStart <= fromEnd
				and: [ (commonElements includes: (split := fromSplits at: fromStart)) not ] ]
				whileTrue: [ start ifNil: [ start := split startIndex ].
					end := split stopIndex.
					fromStart := fromStart + 1 ].
			start
				ifNotNil: [ deletion := GtDeletionDiffChange
							on: from
							from: start
							to: end ].
			start := nil.
			[ toStart <= toEnd
				and: [ (commonElements includes: (split := toSplits at: toStart)) not ] ]
				whileTrue: [ start ifNil: [ start := split startIndex ].
					end := split stopIndex.
					toStart := toStart + 1 ].
			start
				ifNotNil: [ insertion := GtInsertionDiffChange
							on: to
							from: start
							to: end ].
			deletion
				ifNil: [ differences add: insertion ]
				ifNotNil: [ insertion
						ifNil: [ differences add: deletion ]
						ifNotNil: [ differences
								add: (GtReplacementDiffChange delete: deletion andInsert: insertion) ] ].
			[ fromStart <= fromEnd
				and: [ commonElements includes: (fromSplits at: fromStart) ] ]
				whileTrue: [ fromStart := fromStart + 1 ].
			[ toStart <= toEnd and: [ commonElements includes: (toSplits at: toStart) ] ]
				whileTrue: [ toStart := toStart + 1 ] ]
]

{ #category : #private }
GtDiffBuilder >> buildDifferencesList [
	differences := OrderedCollection new.
	fromStart > fromEnd
		ifTrue: [ toStart > toEnd ifTrue: [ ^ self ].
			^ self addInsertions ].
	toStart > toEnd ifTrue: [ ^ self addDeletions ].
	self computeLCSElements
]

{ #category : #computing }
GtDiffBuilder >> computeDifferences [
	self initializeSplits.
	self skipEqualElementsAtStart.
	self skipEqualElementsAtEnd.
	self buildDifferencesList.
	^ GtCompositeDiffChange forChanges: differences
]

{ #category : #private }
GtDiffBuilder >> computeLCSElements [
	| filter filteredFrom filteredTo commonElements |
	filter := Set new.
	fromStart to: fromEnd do: [ :i | filter add: (fromSplits at: i) ].
	filteredTo := OrderedCollection new.
	toStart
		to: toEnd
		do: [ :i | 
			| value |
			(filter includes: (value := toSplits at: i))
				ifTrue: [ filteredTo add: value ] ].
	filter := Set new.
	toStart to: toEnd do: [ :i | filter add: (toSplits at: i) ].
	filteredFrom := OrderedCollection new.
	fromStart
		to: fromEnd
		do: [ :i | 
			| value |
			(filter includes: (value := fromSplits at: i))
				ifTrue: [ filteredFrom add: value ] ].
	commonElements := self computeLCSElementsBetween: filteredFrom and: filteredTo.
	self addInsertionsAndDeletionsIgnoring: commonElements
]

{ #category : #private }
GtDiffBuilder >> computeLCSElementsBetween: filteredFrom and: filteredTo [
	| map fromNumbers toNumbers common lcs |
	common := IdentitySet new.
	(filteredFrom isEmpty or: [ filteredTo isEmpty ]) ifTrue: [ ^ common ].
	map := Dictionary new.
	fromNumbers := filteredFrom
			collect: [ :each | map at: each ifAbsentPut: [ map size ] ].
	toNumbers := filteredTo
			collect: [ :each | map at: each ifAbsentPut: [ map size ] ].
	lcs := self lcsFor: fromNumbers and: toNumbers.
	[ lcs notNil ]
		whileTrue: [ common
				add: (filteredFrom at: lcs first);
				add: (filteredTo at: lcs second).
			lcs := lcs last ].
	^ common
]

{ #category : #accessing }
GtDiffBuilder >> from [
	^ from
]

{ #category : #accessing }
GtDiffBuilder >> from: aCollection [
	from := aCollection
]

{ #category : #private }
GtDiffBuilder >> initializeSplits [
	fromSplits := splitter split: from.
	toSplits := splitter split: to
]

{ #category : #private }
GtDiffBuilder >> lcsFor: fromNumbers and: toNumbers [
	| fromSize toSize endPoints lcss maxSize |
	fromSize := fromNumbers size.
	toSize := toNumbers size.
	maxSize := toSize + fromSize.
	endPoints := Array new: 2 * maxSize + 1.
	endPoints at: maxSize + 2 put: 0.
	lcss := Array new: 2 * maxSize + 1.
	0
		to: maxSize
		do: [ :d | 
			d negated
				to: d
				by: 2
				do: [ :k | 
					| index lcs x y |
					index := maxSize + k.
					(k + d = 0 or: [ k ~= d and: [ (endPoints at: index) < (endPoints at: index + 2) ] ])
						ifTrue: [ x := endPoints at: (index := index + 2) ]
						ifFalse: [ x := (endPoints at: index) + 1 ].
					y := x - k.
					lcs := lcss at: index.
					[ x < fromSize
						and: [ y < toSize and: [ (fromNumbers at: x + 1) = (toNumbers at: y + 1) ] ] ]
						whileTrue: [ lcs := {x := x + 1.
									y := y + 1.
									lcs} ].
					(x >= fromSize and: [ y >= toSize ]) ifTrue: [ ^ lcs ].
					endPoints at: maxSize + k + 1 put: x.
					lcss at: maxSize + k + 1 put: lcs ] ].
]

{ #category : #private }
GtDiffBuilder >> skipEqualElementsAtEnd [
	fromEnd := fromSplits size.
	toEnd := toSplits size.
	[ fromEnd >= fromStart
		and: [ toEnd >= toStart and: [ (fromSplits at: fromEnd) = (toSplits at: toEnd) ] ] ]
		whileTrue: [ fromEnd := fromEnd - 1.
			toEnd := toEnd - 1 ]
]

{ #category : #private }
GtDiffBuilder >> skipEqualElementsAtStart [
	fromStart := 1.
	[ fromStart <= fromSplits size
		and: [ fromStart <= toSplits size
				and: [ (fromSplits at: fromStart) = (toSplits at: fromStart) ] ] ]
		whileTrue: [ fromStart := fromStart + 1 ].
	toStart := fromStart
]

{ #category : #accessing }
GtDiffBuilder >> splitter [
	^ splitter
]

{ #category : #accessing }
GtDiffBuilder >> splitter: aGtDiffSplitter [
	splitter := aGtDiffSplitter
]

{ #category : #accessing }
GtDiffBuilder >> to [
	^ to
]

{ #category : #accessing }
GtDiffBuilder >> to: aCollection [
	to := aCollection
]
