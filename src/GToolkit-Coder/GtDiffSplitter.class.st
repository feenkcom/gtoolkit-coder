Class {
	#name : #GtDiffSplitter,
	#superclass : #Object,
	#instVars : [
		'source'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #actions }
GtDiffSplitter >> split: aCollection [
	| splits |
	splits := GtDiffSplitCollection new.
	self split: aCollection into: splits.
	^ splits
]

{ #category : #actions }
GtDiffSplitter >> split: aCollection into: aGtDiffSplits [
	self subclassResponsibility
]
