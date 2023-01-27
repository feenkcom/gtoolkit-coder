Class {
	#name : #GtSyncScrollRanges1,
	#superclass : #Object,
	#instVars : [
		'ranges'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #'instance creation' }
GtSyncScrollRanges1 class >> createFromChanges: aCompositeChange [
	| syncScroll |
	syncScroll := self new.
	syncScroll buildFromChanges: aCompositeChange.
	^ syncScroll
]

{ #category : #examples }
GtSyncScrollRanges1 class >> example [
	<gtExample>
	^ self createFromChanges: self exampleDiff
]

{ #category : #examples }
GtSyncScrollRanges1 class >> exampleDiff [
	<gtExample>
	^ GtDiffBuilder
		computeDifferencesFrom: self originalString
		to: self newString
		using: GtCharacterGroupDiffSplitter words
]

{ #category : #examples }
GtSyncScrollRanges1 class >> multilineCode [
	<gtExample>
	| change ranges |
	change := GtDiffBuilderExamples new tokenChanges.
	ranges := self createFromChanges: change.
	self assert: ranges ranges size equals: 1.
	^ ranges
]

{ #category : #examples }
GtSyncScrollRanges1 class >> newString [
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
GtSyncScrollRanges1 class >> originalString [
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
GtSyncScrollRanges1 class >> reversedMultilineCode [
	<gtExample>
	| change ranges |
	change := GtDiffBuilderExamples new reversedTokenChanges.
	ranges := self createFromChanges: change.
	self assert: ranges ranges size equals: 1.
	^ ranges
]

{ #category : #initialization }
GtSyncScrollRanges1 >> addDestinationLineChangesFrom: aCompositeChange to: changedLines [
	| lineNumber index |
	lineNumber := 0.
	index := 1.
	aCompositeChange to
		lineIndicesDo: [ :start :end :endWithCR | 
			[ | currentChange previousIndex |
			previousIndex := index.
			currentChange := aCompositeChange changes at: index.
			currentChange insertionChange
				ifNil: [ currentChange deletionChange
						ifNotNil: [ :change | 
							change newIndex <= endWithCR
								ifTrue: [ (changedLines at: currentChange)
										add: lineNumber;
										add: lineNumber.
									index := index + 1 ] ] ]
				ifNotNil: [ :change | 
					(change startIndex between: start and: endWithCR)
						ifTrue: [ (changedLines at: currentChange) add: lineNumber ].
					change stopIndex <= endWithCR
						ifTrue: [ (changedLines at: currentChange) add: lineNumber + 1.
							index := index + 1 ] ].
			index > aCompositeChange changes size ifTrue: [ ^ self ].
			previousIndex ~= index ] whileTrue.
			lineNumber := lineNumber + 1 ].
	(changedLines at: aCompositeChange changes last) add: lineNumber
]

{ #category : #initialization }
GtSyncScrollRanges1 >> addOriginalLineChangesFrom: aCompositeChange to: changedLines [
	| lineNumber index |
	lineNumber := 0.
	index := 1.
	aCompositeChange from
		lineIndicesDo: [ :start :end :endWithCR | 
			[ | currentChange previousIndex |
			previousIndex := index.
			currentChange := aCompositeChange changes at: index.
			currentChange deletionChange
				ifNil: [ currentChange insertionChange
						ifNotNil: [ :change | 
							change originalIndex <= endWithCR
								ifTrue: [ changedLines
										at: currentChange
										ifAbsentPut: [ OrderedCollection with: lineNumber with: lineNumber ].
									index := index + 1 ] ] ]
				ifNotNil: [ :change | 
					change startIndex < endWithCR
						ifTrue: [ changedLines
								at: currentChange
								ifAbsentPut: [ OrderedCollection with: lineNumber ] ].
					change stopIndex <= endWithCR
						ifTrue: [ (changedLines at: currentChange) add: lineNumber + 1.
							index := index + 1 ] ].
			index > aCompositeChange changes size ifTrue: [ ^ self ].
			previousIndex ~= index ] whileTrue.
			lineNumber := lineNumber + 1 ].
	(changedLines
		at: aCompositeChange changes last
		ifAbsentPut: [ OrderedCollection with: lineNumber ]) add: lineNumber
]

{ #category : #initialization }
GtSyncScrollRanges1 >> addRanges: changedRanges fromChanges: aCompositeChange [
	| fromStart toStart fromEnd toEnd |
	fromEnd := aCompositeChange from lineCount.
	toEnd := aCompositeChange to lineCount.
	fromStart := 0.
	toStart := 0.
	changedRanges
		do: [ :each | 
			(ranges isEmpty and: [ each first = 0 and: [ each third = 0 ] ])
				ifFalse: [ ranges
						add: (GtSyncScrollRange
								leftFirst: fromStart
								leftLast: each first - 1
								rightFirst: toStart
								rightLast: each third - 1) ].
			ranges
				add: (GtSyncScrollRange
						leftFirst: each first
						leftLast: each second
						rightFirst: each third
						rightLast: each fourth) beDifferent.
			fromStart := each second + 1.
			toStart := each fourth + 1 ].
	(fromStart > fromEnd and: [ toStart > toEnd ])
		ifFalse: [ ranges
				add: (GtSyncScrollRange
						leftFirst: fromStart
						leftLast: fromEnd
						rightFirst: toStart
						rightLast: toEnd) ]
]

{ #category : #initialization }
GtSyncScrollRanges1 >> buildFromChanges: aCompositeChange [
	| changedLines changedRanges |
	changedLines := IdentityDictionary new.
	self addOriginalLineChangesFrom: aCompositeChange to: changedLines.
	self addDestinationLineChangesFrom: aCompositeChange to: changedLines.
	changedRanges := changedLines values
			asSortedCollection: [ :a :b | a first < b first or: [ a first = b first and: [ a third < b third ] ] ].
	changedRanges := self mergeRanges: changedRanges.
	self addRanges: changedRanges fromChanges: aCompositeChange
]

{ #category : #accessing }
GtSyncScrollRanges1 >> gtRangesViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Ranges';
		items: [ ranges ];
		column: 'Left'
			text: [ :each | each leftRangeDisplayString asRopedText glamorousRegularFont ];
		column: 'Right'
			text: [ :each | each rightRangeDisplayString asRopedText glamorousRegularFont ];
		column: 'Equal'
			text: [ :each | each isDifference not asString asRopedText glamorousRegularFont ]
]

{ #category : #'initialize-release' }
GtSyncScrollRanges1 >> initialize [
	super initialize.
	ranges := OrderedCollection new
]

{ #category : #accessing }
GtSyncScrollRanges1 >> leftLineFor: rightIndex [
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
GtSyncScrollRanges1 >> mergeDifferences [
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

{ #category : #initialization }
GtSyncScrollRanges1 >> mergeRanges: changedRanges [
	| newRanges |
	newRanges := OrderedCollection new.
	changedRanges
		do: [ :each | 
			(newRanges notEmpty
				and: [ (newRanges last at: 2) >= (each at: 1)
						or: [ (newRanges last at: 4) >= (each at: 3) ] ])
				ifTrue: [ | lastRange |
					lastRange := newRanges last.
					lastRange at: 2 put: ((each at: 2) max: (lastRange at: 2)).
					lastRange at: 4 put: ((each at: 4) max: (lastRange at: 4)) ]
				ifFalse: [ newRanges add: each ] ].
	^ newRanges
]

{ #category : #accessing }
GtSyncScrollRanges1 >> ranges [
	^ ranges
]

{ #category : #accessing }
GtSyncScrollRanges1 >> rangesForLeft: leftInterval andRight: rightInterval [
	^ ranges
		select: [ :each | each overlapsLeft: leftInterval orRight: rightInterval ]
]

{ #category : #accessing }
GtSyncScrollRanges1 >> rightLineFor: leftIndex [
	| range |
	range := ranges
		detect: [ :each | leftIndex between: each leftFirst and: each leftLast ]
		ifNone: [ ^ 0 ].
	range leftSize = 0
		ifTrue: [ ^ 0 ].
	^ ((leftIndex asFloat - range leftFirst) / range leftSize
		* range rightSize + range rightFirst) rounded 
]
