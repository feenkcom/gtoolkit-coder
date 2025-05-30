Class {
	#name : #GtDiffBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #examples }
GtDiffBuilderExamples >> byteArrayDiff [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| originalByteArray modifiedByteArray |
	originalByteArray := (1 to: 64)
			collect: [ :_ | 256 atRandom - 1 ]
			as: ByteArray.
	modifiedByteArray := originalByteArray copy.
	8
		timesRepeat: [ modifiedByteArray at: modifiedByteArray size atRandom put: 256 atRandom - 1 ].
	^ GtDiffBuilder
		computeDifferencesFrom: originalByteArray
		to: modifiedByteArray
		using: GtNullDiffSplitter new
]

{ #category : #examples }
GtDiffBuilderExamples >> changeInMiddleAndDeletionAtEnd [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := String cr join: ((1 to: 10) collect: #asWords).
	to := String cr
			join: (((1 to: 10) collect: #asWords)
					at: 2 put: 'two plus';
					allButLast).
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter ignoringEOLChars.
	differences := change changes.
	self assert: differences size equals: 2.
	self assert: differences first isReplacement.
	self assert: differences first deletedObjects equals: 'two'.
	self assert: differences first insertedObjects equals: 'two plus'.
	self assert: differences second isDeletion.
	self assert: differences second deletedObjects equals: 'ten'.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> deletionsAtBeginningExample [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := '1' , String cr , '2' , String lf , '3'.
	to := from allButFirst: 2.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isDeletion.
	self assert: differences first startIndex equals: 1.
	self assert: differences first stopIndex equals: 2.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> deletionsAtEndExample [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := '1' , String cr , '2' , String lf , '3'.
	to := from allButLast.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isDeletion.
	self assert: differences first startIndex equals: from size.
	self assert: differences first stopIndex equals: from size.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> deletionsInMiddle [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := String cr join: ((1 to: 9) collect: #printString).
	to := String cr join: ((1 to: 4) , (7 to: 9) collect: #printString).
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isDeletion.
	self assert: differences first startIndex equals: 9.
	self assert: differences first stopIndex equals: 12.
	self assert: differences first newIndex equals: 9.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> insertionsAtBeginningExample [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	to := '1' , String cr , '2' , String lf , '3'.
	from := to allButFirst: 2.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isInsertion.
	self assert: differences first startIndex equals: 1.
	self assert: differences first stopIndex equals: 2.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> insertionsAtEndExample [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	to := '1' , String cr , '2' , String lf , '3'.
	from := to allButLast.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isInsertion.
	self assert: differences first startIndex equals: to size.
	self assert: differences first stopIndex equals: to size.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> insertionsInMiddle [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	to := String cr join: ((1 to: 9) collect: #printString).
	from := String cr join: ((1 to: 4) , (7 to: 9) collect: #printString).
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isInsertion.
	self assert: differences first startIndex equals: 9.
	self assert: differences first stopIndex equals: 12.
	self assert: differences first originalIndex equals: 9.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> multipleChanges [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := String cr join: ((0 to: 9 by: 3) collect: #printString).
	to := String cr join: ((0 to: 9 by: 2) collect: #printString).
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 2.
	self assert: differences first isReplacement.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> multipleObjectChanges [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to deletedObjects insertedObjects index change |
	from := 0 to: 1000 by: 2.
	to := 0 to: 1000 by: 7.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtNullDiffSplitter new.
	differences := change changes.
	deletedObjects := OrderedCollection new.
	insertedObjects := OrderedCollection new.
	differences
		do: [ :each | 
			each deletedObjects ifNotNil: [ :objs | deletedObjects addAll: objs ].
			each insertedObjects ifNotNil: [ :objs | insertedObjects addAll: objs ] ].
	index := 1.
	from
		do: [ :each | 
			(to includes: each)
				ifTrue: [ self assert: (deletedObjects includes: each) not ]
				ifFalse: [ self assert: (deletedObjects at: index) equals: each.
					index := index + 1 ] ].
	index := 1.
	to
		do: [ :each | 
			(from includes: each)
				ifTrue: [ self assert: (insertedObjects includes: each) not ]
				ifFalse: [ self assert: (insertedObjects at: index) equals: each.
					index := index + 1 ] ].
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> noDifferencesExample [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := '1' , String cr , '2' , String lf , '3'.
	to := from copy.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 0.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> replacementInMiddle [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change |
	from := String cr join: ((1 to: 4) , (6 to: 9) collect: #printString).
	to := String cr join: ((1 to: 5) , (7 to: 9) collect: #printString).
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: GtLineDiffSplitter new.
	differences := change changes.
	self assert: differences size equals: 1.
	self assert: differences first isReplacement.
	self assert: differences first deletionChange startIndex equals: 9.
	self assert: differences first deletionChange stopIndex equals: 10.
	self assert: differences first insertionChange startIndex equals: 9.
	self assert: differences first insertionChange stopIndex equals: 10.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> reversedTokenChanges [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change scannerClass |
	scannerClass := self class environment at: #GtPharoScanner ifAbsent: [ ^ nil ].
	to := 'method: arg ^self inject: arg into: [:sum :each | sum + each]'.
	from := 'method: arg1
		^ self 
			inject: arg1 
			into: [:sum :each | (sum + each)]'.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: (GtSmaCCDiffSplitter new scannerClass: scannerClass).
	differences := change changes.
	self assert: differences size equals: 4.
	self assert: differences first isReplacement.
	self assert: differences first deletionChange objects equals: 'arg1'.
	self assert: differences first insertionChange objects equals: 'arg'.
	self assert: differences second isReplacement.
	self assert: differences second deletionChange objects equals: 'arg1'.
	self assert: differences second insertionChange objects equals: 'arg'.
	self assert: differences third isDeletion.
	self assert: differences third objects equals: '('.
	self assert: differences fourth isDeletion.
	self assert: differences fourth objects equals: ')'.
	^ change
]

{ #category : #examples }
GtDiffBuilderExamples >> tokenChanges [
	<gtExample>
	<return: #GtCompositeDiffChange>
	| differences from to change scannerClass |
	scannerClass := self class environment at: #GtPharoScanner ifAbsent: [ ^ nil ].
	from := 'method: arg ^self inject: arg into: [:sum :each | sum + each]'.
	to := 'method: arg1
		^ self 
			inject: arg1 
			into: [:sum :each | (sum + each)]'.
	change := GtDiffBuilder
			computeDifferencesFrom: from
			to: to
			using: (GtSmaCCDiffSplitter new scannerClass: scannerClass).
	differences := change changes.
	self assert: differences size equals: 4.
	self assert: differences first isReplacement.
	self assert: differences first deletionChange objects equals: 'arg'.
	self assert: differences first insertionChange objects equals: 'arg1'.
	self assert: differences second isReplacement.
	self assert: differences second deletionChange objects equals: 'arg'.
	self assert: differences second insertionChange objects equals: 'arg1'.
	self assert: differences third isInsertion.
	self assert: differences third objects equals: '('.
	self assert: differences fourth isInsertion.
	self assert: differences fourth objects equals: ')'.
	^ change
]
