Class {
	#name : #GtSmaCCDiffSplitter,
	#superclass : #GtDiffSplitter,
	#instVars : [
		'scannerClass',
		'string'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtSmaCCDiffSplitter >> createCommentSplitFrom: start to: stop into: aGtDiffSplits [
	aGtDiffSplits
		addSplit: (GtRangeDiffSplit
				on: string
				from: start
				to: stop)
]

{ #category : #accessing }
GtSmaCCDiffSplitter >> createTokenSplitFrom: aToken into: aGtDiffSplits [
	aGtDiffSplits
		addSplit: (GtRangeDiffSplit
				on: string
				from: aToken startPosition
				to: aToken stopPosition)
]

{ #category : #'as yet unclassified' }
GtSmaCCDiffSplitter >> descriptionString [
	^ 'using ' , self scannerClass asString
]

{ #category : #'as yet unclassified' }
GtSmaCCDiffSplitter >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: scannerClass asString;
		nextPut: $)
]

{ #category : #accessing }
GtSmaCCDiffSplitter >> scannerClass [
	^ scannerClass
]

{ #category : #accessing }
GtSmaCCDiffSplitter >> scannerClass: aSmaCCScannerClass [
	scannerClass := aSmaCCScannerClass
]

{ #category : #accessing }
GtSmaCCDiffSplitter >> split: aString into: aGtDiffSplits [
	| scanner commentIndex token |
	string := aString.
	scanner := scannerClass on: string readStream.
	commentIndex := 0.
	[ token := scanner next.
	[ commentIndex < scanner comments size ]
		whileTrue: [ commentIndex := commentIndex + 1.
			self
				createCommentSplitFrom: (scanner comments at: commentIndex) first
				to: (scanner comments at: commentIndex) last
				into: aGtDiffSplits ].
	token ids first ~= scanner emptySymbolTokenId ]
		whileTrue: [ self createTokenSplitFrom: token into: aGtDiffSplits ]
]
