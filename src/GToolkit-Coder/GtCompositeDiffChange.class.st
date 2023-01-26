Class {
	#name : #GtCompositeDiffChange,
	#superclass : #GtDiffChange,
	#instVars : [
		'changes'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtCompositeDiffChange class >> forChanges: aCollection [
	^ self new
		changes: aCollection;
		yourself
]

{ #category : #accessing }
GtCompositeDiffChange >> changes [
	^ changes
]

{ #category : #accessing }
GtCompositeDiffChange >> changes: aCollection [
	changes := aCollection
]

{ #category : #accessing }
GtCompositeDiffChange >> gtChangeViewFor: aView [
	<gtView>
	^ aView columnedTree
		priority: 10;
		title: 'Changes';
		items: [ self changes ];
		children: [ :each | 
			each isReplacement
				ifTrue: [ {each deletionChange.
						each insertionChange} ]
				ifFalse: [ #() ] ];
		column: 'Kind'
			text: [ :each | (each class name removePrefix: 'Gt') removeSuffix: 'DiffChange' ]
			width: 150;
		column: 'Range'
			text: [ :each | each range ]
			width: 100;
		column: 'Objects' text: [ :each | each gtObjectsText ]
]

{ #category : #initialization }
GtCompositeDiffChange >> initialize [
	super initialize.
	changes := #()
]
