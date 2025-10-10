Class {
	#name : #GtLineDiffSplitter,
	#superclass : #GtDiffSplitter,
	#instVars : [
		'includeEOLChars'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtLineDiffSplitter class >> ignoringEOLChars [
	^ self new
		includeEOLChars: false;
		yourself
]

{ #category : #'as yet unclassified' }
GtLineDiffSplitter >> descriptionString [
	^ 'by lines'
]

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

{ #category : #testing }
GtLineDiffSplitter >> isLineBased [
	^ true
]

{ #category : #actions }
GtLineDiffSplitter >> split: aString into: aGtDiffSplits [
	aString
		lineIndicesDo: [ :start :end :endWithEOL | 
			aGtDiffSplits
				addSplit: (GtRangeDiffSplit
						on: aString
						from: start
						to: (includeEOLChars ifTrue: [ endWithEOL ] ifFalse: [ end ])) ]
]
