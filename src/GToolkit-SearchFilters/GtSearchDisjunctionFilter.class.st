Class {
	#name : #GtSearchDisjunctionFilter,
	#superclass : #GtSearchBinaryFilter,
	#category : #'GToolkit-SearchFilters-Filters'
}

{ #category : #accessing }
GtSearchDisjunctionFilter >> defaultFilterScope [
	^ left defaultFilterScope
]

{ #category : #printing }
GtSearchDisjunctionFilter >> gtDisplayOn: stream [
	left gtDisplayOn: stream.
	stream nextPutAll: ' - '.
	right gtDisplayOn: stream.
]

{ #category : #testing }
GtSearchDisjunctionFilter >> matches: anObject [
	| leftResult rightResult |
	leftResult := left matches: anObject.
	rightResult := right matches: anObject.

	^ leftResult ifTrue: [ rightResult not ] ifFalse: [ rightResult ]
]

{ #category : #printing }
GtSearchDisjunctionFilter >> printOn: stream [
	left printOn: stream.
	stream nextPutAll: ' - '.
	right printOn: stream.
]
