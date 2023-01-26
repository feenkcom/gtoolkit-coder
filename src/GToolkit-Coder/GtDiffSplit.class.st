Class {
	#name : #GtDiffSplit,
	#superclass : #Object,
	#instVars : [
		'source',
		'startIndex'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #comparing }
GtDiffSplit >> = anObject [
	^ self class = anObject class ifTrue: [ self object = anObject object ]
]

{ #category : #comparing }
GtDiffSplit >> hash [
	^ self object hash
]

{ #category : #accessing }
GtDiffSplit >> object [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtDiffSplit >> source [
	^ source
]

{ #category : #accessing }
GtDiffSplit >> source: aCollection [
	source := aCollection
]

{ #category : #accessing }
GtDiffSplit >> startIndex [
	^ startIndex
]

{ #category : #accessing }
GtDiffSplit >> startIndex: anInteger [
	startIndex := anInteger
]

{ #category : #accessing }
GtDiffSplit >> stopIndex [
	^ self subclassResponsibility
]
