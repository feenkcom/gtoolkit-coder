Class {
	#name : #GtLineDiffSplitter,
	#superclass : #GtDiffSplitter,
	#instVars : [
		'includeEOLChars'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #accessing }
GtLineDiffSplitter >> includeEOLChars [
	^ includeEOLChars
]

{ #category : #accessing }
GtLineDiffSplitter >> includeEOLChars: aBoolean [
	includeEOLChars := aBoolean
]

{ #category : #initialization }
GtLineDiffSplitter >> initialize [
	super initialize.
	includeEOLChars := true
]

{ #category : #actions }
GtLineDiffSplitter >> split: aString [
	| splits |
	splits := OrderedCollection new.
	aString
		lineIndicesDo: [ :start :end :endWithEOL | 
			splits
				add: (GtRangeDiffSplit
						on: aString
						from: start
						to: (includeEOLChars ifTrue: [ endWithEOL ] ifFalse: [ end ])) ].
	^ splits
]
