Class {
	#name : #GtSyncScrollRange,
	#superclass : #Object,
	#instVars : [
		'leftFirst',
		'leftLast',
		'rightFirst',
		'rightLast',
		'isDifference'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #'instance creation' }
GtSyncScrollRange class >> left: leftInteger right: rightInteger [
	^ self new
		initializeLeft: leftInteger right: rightInteger;
		yourself
]

{ #category : #'instance creation' }
GtSyncScrollRange class >> leftFirst: leftFirst leftLast: leftLast rightFirst: rightFirst rightLast: rightLast [
	^ self new
		leftFirst: leftFirst;
		leftLast: leftLast;
		rightFirst: rightFirst;
		rightLast: rightLast;
		yourself
]

{ #category : #syncing }
GtSyncScrollRange >> advanceBoth [
	self leftSize = self rightSize
		ifTrue: [ leftLast := leftLast + 1.
			rightLast := rightLast + 1.
			^ nil ].
	^ (GtSyncScrollRange left: leftLast right: rightLast)
		advanceBoth;
		yourself
]

{ #category : #syncing }
GtSyncScrollRange >> advanceLeft [
	self rightSize = 0
		ifTrue: [ isDifference := true.
			leftLast := leftLast + 1.
			^ nil ].
	^ (GtSyncScrollRange left: leftLast right: rightLast)
		advanceLeft;
		yourself
]

{ #category : #syncing }
GtSyncScrollRange >> advanceRight [
	self leftSize = 0
		ifTrue: [ isDifference := true.
			rightLast := rightLast + 1.
			^ nil ].
	^ (GtSyncScrollRange left: leftLast right: rightLast)
		advanceRight;
		yourself
]

{ #category : #accessing }
GtSyncScrollRange >> beDifferent [
	isDifference := true
]

{ #category : #'initialize-release' }
GtSyncScrollRange >> initialize [
	super initialize.
	isDifference := false.
	leftFirst := 0.
	leftLast := 0.
	rightFirst := 0.
	rightLast := 0
]

{ #category : #'initialize-release' }
GtSyncScrollRange >> initializeLeft: leftInteger right: rightInteger [
	leftFirst := leftInteger.
	leftLast := leftInteger.
	rightFirst := rightInteger.
	rightLast := rightInteger
]

{ #category : #testing }
GtSyncScrollRange >> isDifference [
	^ isDifference
]

{ #category : #accessing }
GtSyncScrollRange >> leftFirst [
	^ leftFirst
]

{ #category : #accessing }
GtSyncScrollRange >> leftFirst: anInteger [
	leftFirst := anInteger
]

{ #category : #accessing }
GtSyncScrollRange >> leftLast [
	^ leftLast
]

{ #category : #accessing }
GtSyncScrollRange >> leftLast: anInteger [
	leftLast := anInteger
]

{ #category : #accessing }
GtSyncScrollRange >> leftRangeDisplayString [
	^ leftFirst printString , '-' , leftLast printString
]

{ #category : #accessing }
GtSyncScrollRange >> leftSize [
	^ leftLast - leftFirst
]

{ #category : #'initialize-release' }
GtSyncScrollRange >> markDifferent [
	isDifference := true
]

{ #category : #'initialize-release' }
GtSyncScrollRange >> markSame [
	isDifference := false
]

{ #category : #syncing }
GtSyncScrollRange >> mergeWith: aRange [
	leftFirst := leftFirst min: aRange leftFirst.
	leftLast := leftLast max: aRange leftLast.
	rightFirst := rightFirst min: aRange rightFirst.
	rightLast := rightLast max: aRange rightLast
]

{ #category : #testing }
GtSyncScrollRange >> overlapsLeft: leftInterval orRight: rightInterval [
	^ ((self leftLast < leftInterval first
		or: [ self leftFirst > leftInterval last ])
		and: [ self rightLast < rightInterval first
				or: [ self rightFirst > rightInterval last ] ]) not
]

{ #category : #printing }
GtSyncScrollRange >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $[;
		print: leftFirst;
		nextPut: $-;
		print: leftLast;
		nextPutAll:
			(isDifference
				ifTrue: [ '<=>' ]
				ifFalse: [ '===' ]);
		print: rightFirst;
		nextPut: $-;
		print: rightLast;
		nextPut: $]
]

{ #category : #accessing }
GtSyncScrollRange >> rightFirst [
	^ rightFirst
]

{ #category : #accessing }
GtSyncScrollRange >> rightFirst: anInteger [
	rightFirst := anInteger
]

{ #category : #accessing }
GtSyncScrollRange >> rightLast [
	^ rightLast
]

{ #category : #accessing }
GtSyncScrollRange >> rightLast: anInteger [
	rightLast := anInteger
]

{ #category : #accessing }
GtSyncScrollRange >> rightRangeDisplayString [
	^ rightFirst printString , '-' , rightLast printString
]

{ #category : #accessing }
GtSyncScrollRange >> rightSize [
	^ rightLast - rightFirst
]
