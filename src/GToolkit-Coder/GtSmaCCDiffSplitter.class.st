Class {
	#name : #GtSmaCCDiffSplitter,
	#superclass : #GtDiffSplitter,
	#instVars : [
		'scannerClass'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

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
	scanner := scannerClass on: aString readStream.
	commentIndex := 0.
	[ token := scanner next.
	[ commentIndex < scanner comments size ]
		whileTrue: [ commentIndex := commentIndex + 1.
			aGtDiffSplits
				addSplit: (GtRangeDiffSplit
						on: aString
						from: (scanner comments at: commentIndex) first
						to: (scanner comments at: commentIndex) last) ].
	token ids first ~= scanner emptySymbolTokenId ]
		whileTrue: [ aGtDiffSplits
				addSplit: (GtRangeDiffSplit
						on: aString
						from: token startPosition
						to: token stopPosition) ]
]
