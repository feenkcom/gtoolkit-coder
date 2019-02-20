Class {
	#name : #GtSearchUnionFilter,
	#superclass : #GtSearchBinaryFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #printing }
GtSearchUnionFilter >> gtDisplayOn: stream [
	left gtDisplayOn: stream.
	stream nextPutAll: ' | '.
	right gtDisplayOn: stream.

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
