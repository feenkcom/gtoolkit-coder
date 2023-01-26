Class {
	#name : #GtDiffSplitCollection,
	#superclass : #Object,
	#instVars : [
		'splits'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #adding }
GtDiffSplitCollection >> addSplit: aGtDiffSplit [
	splits add: aGtDiffSplit
]

{ #category : #accessing }
GtDiffSplitCollection >> at: anInteger [
	^ splits at: anInteger
]

{ #category : #accessing }
GtDiffSplitCollection >> gtLiveFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Splits';
		items: [ self splits ];
		column: 'Range'
			text: [ :each | each range ]
			width: 100;
		column: 'Value' text: [ :each | each object ]
]

{ #category : #initialization }
GtDiffSplitCollection >> initialize [
	super initialize.
	splits := OrderedCollection new
]

{ #category : #accessing }
GtDiffSplitCollection >> size [
	^ splits size
]

{ #category : #accessing }
GtDiffSplitCollection >> splits [
	^ splits
]

{ #category : #accessing }
GtDiffSplitCollection >> splits: aCollection [
	splits := aCollection
]
