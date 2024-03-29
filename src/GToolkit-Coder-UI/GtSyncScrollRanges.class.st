Class {
	#name : #GtSyncScrollRanges,
	#superclass : #Object,
	#instVars : [
		'ranges'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #'instance creation' }
GtSyncScrollRanges class >> createFromChange: aCompositeChange [
	| syncScroll |
	syncScroll := self new.
	syncScroll buildFromChange: aCompositeChange.
	^ syncScroll
]

{ #category : #'instance creation' }
GtSyncScrollRanges class >> createFromDiff: aDiffBuilder [
	| syncScroll |
	syncScroll := self new.
	syncScroll buildFromDiff: aDiffBuilder.
	^ syncScroll
]

{ #category : #'private-creation changes' }
GtSyncScrollRanges >> addDestinationLineChangesFrom: aCompositeChange to: changedLines [
	| lineNumber index lineNumbers |
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
	lineNumbers := changedLines at: aCompositeChange changes last.
	[ lineNumbers size < 4 ] whileTrue: [ lineNumbers add: lineNumber ]
]

{ #category : #'private-creation changes' }
GtSyncScrollRanges >> addOriginalLineChangesFrom: aCompositeChange to: changedLines [
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
					change startIndex <= endWithCR
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

{ #category : #'private-creation changes' }
GtSyncScrollRanges >> addRanges: changedRanges fromChanges: aCompositeChange [
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
								leftLast: each first
								rightFirst: toStart
								rightLast: each third) ].
			ranges
				add: (GtSyncScrollRange
						leftFirst: each first
						leftLast: each second
						rightFirst: each third
						rightLast: each fourth) beDifferent.
			fromStart := each second.
			toStart := each fourth ].
	(fromStart + 1 > fromEnd and: [ toStart + 1 > toEnd ])
		ifFalse: [ ranges
				add: (GtSyncScrollRange
						leftFirst: fromStart
						leftLast: fromEnd
						rightFirst: toStart
						rightLast: toEnd) ]
]

{ #category : #'private-creation diff' }
GtSyncScrollRanges >> advanceBoth [
	ranges last advanceBoth ifNotNil: [ :range | ranges add: range ]
]

{ #category : #'private-creation diff' }
GtSyncScrollRanges >> advanceLeft [
	ranges last advanceLeft ifNotNil: [ :range | ranges add: range ]
]

{ #category : #'private-creation diff' }
GtSyncScrollRanges >> advanceRight [
	ranges last advanceRight ifNotNil: [ :range | ranges add: range ]
]

{ #category : #'private-creation changes' }
GtSyncScrollRanges >> buildFromChange: aCompositeChange [
	| changedLines changedRanges |
	ranges := OrderedCollection new.
	changedLines := IdentityDictionary new.
	aCompositeChange changes notEmpty
		ifTrue: [ self addOriginalLineChangesFrom: aCompositeChange to: changedLines.
			self addDestinationLineChangesFrom: aCompositeChange to: changedLines ].
	changedRanges := changedLines values
			asSortedCollection: [ :a :b | a first < b first or: [ a first = b first and: [ a third < b third ] ] ].
	changedRanges := self mergeRanges: changedRanges.
	self addRanges: changedRanges fromChanges: aCompositeChange
]

{ #category : #'private-creation diff' }
GtSyncScrollRanges >> buildFromDiff: aDiffBuilder [
	ranges := OrderedCollection with: GtSyncScrollRange new.
	aDiffBuilder
		patchSequenceDoIfMatch: [ :line | self advanceBoth ]
		ifInsert: [ :line | self advanceRight ]
		ifRemove: [ :line | self advanceLeft ].
	self mergeDifferences
]

{ #category : #inspecting }
GtSyncScrollRanges >> gtRangesViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Ranges';
		items: [ self ranges ];
		column: 'Left'
			text: [ :each | each leftRangeDisplayString asRopedText glamorousRegularFont ];
		column: 'Right'
			text: [ :each | each rightRangeDisplayString asRopedText glamorousRegularFont ];
		column: 'Equal'
			text: [ :each | each isDifference not asString asRopedText glamorousRegularFont ]
]

{ #category : #accessing }
GtSyncScrollRanges >> leftLineFor: anInteger [
	| range rightIndex |
	rightIndex := self ranges notEmpty
			ifTrue: [ (self ranges last rightLast min: anInteger) max: self ranges first rightFirst ]
			ifFalse: [ anInteger ].
	range := self ranges
			detect: [ :each | rightIndex between: each rightFirst and: each rightLast ]
			ifNone: [ ^ 0 ].
	^ ((range rightSize = 0
		ifTrue: [ 0 ]
		ifFalse: [ (rightIndex asFloat - range rightFirst) / range rightSize ])
		* range leftSize + range leftFirst) rounded
]

{ #category : #'private-creation diff' }
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

{ #category : #'private-creation changes' }
GtSyncScrollRanges >> mergeRanges: changedRanges [
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
GtSyncScrollRanges >> rangeForLeft: anInteger [
	^ self ranges
		detect: [ :each | each includesLeftLine: anInteger ]
		ifNone: [  ]
]

{ #category : #accessing }
GtSyncScrollRanges >> rangeForRight: anInteger [
	^ self ranges
		detect: [ :each | each includesRightLine: anInteger ]
		ifNone: [  ]
]

{ #category : #accessing }
GtSyncScrollRanges >> ranges [
	^ ranges ifNil: [ #() ]
]

{ #category : #accessing }
GtSyncScrollRanges >> rangesForLeft: leftInterval andRight: rightInterval [
	^ self ranges
		select: [ :each | each overlapsLeft: leftInterval orRight: rightInterval ]
]

{ #category : #accessing }
GtSyncScrollRanges >> rightLineFor: anInteger [
	| range leftIndex |
	leftIndex := self ranges notEmpty
			ifTrue: [ (self ranges last leftLast min: anInteger) max: self ranges first leftFirst ]
			ifFalse: [ anInteger ].
	range := self ranges
			detect: [ :each | leftIndex between: each leftFirst and: each leftLast ]
			ifNone: [ ^ 0 ].
	^ ((range leftSize = 0
		ifTrue: [ 0 ]
		ifFalse: [ (leftIndex asFloat - range leftFirst) / range leftSize ])
		* range rightSize + range rightFirst) rounded
]

{ #category : #accessing }
GtSyncScrollRanges >> selectNext [
	| found |
	found := false.
	self ranges isEmpty ifTrue: [ ^ self ].
	self ranges
		do: [ :each | 
			found
				ifTrue: [ each isDifference ifTrue: [ ^ each select ] ]
				ifFalse: [ found := each isSelected ].
			each unselect ].
	^ (self ranges
		detect: [ :each | each isDifference ]
		ifNone: [ self ranges first ]) select
]

{ #category : #accessing }
GtSyncScrollRanges >> selectPrevious [
	| found |
	found := false.
	self ranges isEmpty ifTrue: [ ^ self ].
	self ranges
		reverseDo: [ :each | 
			found
				ifTrue: [ each isDifference ifTrue: [ ^ each select ] ]
				ifFalse: [ found := each isSelected ].
			each unselect ].
	self ranges size
		to: 1
		by: -1
		do: [ :i | 
			| range |
			range := self ranges at: i.
			range isDifference ifTrue: [ ^ range select ] ].
	^ self ranges last select
]

{ #category : #accessing }
GtSyncScrollRanges >> selectRange: aRange [
	self ranges do: [ :each | each unselect ].
	aRange ifNotNil: [ aRange select ]
]

{ #category : #accessing }
GtSyncScrollRanges >> selectedProgress [
	| index |
	index := {0. 0}.
	self ranges
		do: [ :each | 
			each isDifference
				ifTrue: [ index at: 2 put: index last + 1.
					each isSelected ifTrue: [ index at: 1 put: index last ] ] ].
	^ index
]
