Class {
	#name : #GtSearchUnionFilter,
	#superclass : #GtSearchBinaryFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchUnionFilter >> defaultFilterScope [
	^ left defaultFilterScope = right defaultFilterScope
		ifTrue: [ left defaultFilterScope ]
		ifFalse: [ self ]
]

{ #category : #printing }
GtSearchUnionFilter >> gtDisplayOn: stream [
	left gtDisplayOn: stream.
	stream nextPutAll: ' | '.
	right gtDisplayOn: stream.

]

{ #category : #enumerating }
GtSearchUnionFilter >> itemsDo: aBloc [
	left defaultFilterScope itemsDo: aBloc.
	right defaultFilterScope itemsDo: aBloc.
]

{ #category : #testing }
GtSearchUnionFilter >> matches: anObject [
	^ (left matches: anObject) or: [ right matches: anObject ]
]

{ #category : #printing }
GtSearchUnionFilter >> printOn: stream [
	left printOn: stream.
	stream nextPutAll: ' | '.
	right printOn: stream.

]
