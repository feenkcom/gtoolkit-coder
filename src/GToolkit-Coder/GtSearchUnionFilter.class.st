Class {
	#name : #GtSearchUnionFilter,
	#superclass : #GtSearchBinaryFilter,
	#category : 'GToolkit-Coder-Filters'
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
GtSearchUnionFilter >> itemsDo: aBlock [
	| seen |
	seen := IdentitySet new.
	left defaultFilterScope
		itemsDo: [ :each | 
			seen add: each.
			aBlock value: each ].
	right defaultFilterScope
		itemsDo: [ :each | 
			(seen includes: each)
				ifFalse: [ aBlock value: each ] ]
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
