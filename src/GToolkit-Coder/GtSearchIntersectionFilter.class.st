Class {
	#name : #GtSearchIntersectionFilter,
	#superclass : #GtSearchBinaryFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #printing }
GtSearchIntersectionFilter >> gtDisplayOn: stream [
	left gtDisplayOn: stream.
	stream nextPutAll: ' & '.
	right gtDisplayOn: stream.
]

{ #category : #testing }
GtSearchIntersectionFilter >> matches: anObject [
	^ (left matches: anObject) and: [ right matches: anObject ]
]

{ #category : #printing }
GtSearchIntersectionFilter >> printOn: stream [
	left printOn: stream.
	stream nextPutAll: ' & '.
	right printOn: stream.
]
