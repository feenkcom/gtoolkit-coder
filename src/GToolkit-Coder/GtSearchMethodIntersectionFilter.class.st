Class {
	#name : #GtSearchMethodIntersectionFilter,
	#superclass : #GtSearchBinaryMethodFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #printing }
GtSearchMethodIntersectionFilter >> gtDisplayOn: stream [
	left gtDisplayOn: stream.
	stream nextPutAll: ' & '.
	right gtDisplayOn: stream.
]

{ #category : #testing }
GtSearchMethodIntersectionFilter >> includeMethod: anObject [
	^ (left includeMethod: anObject) and: [ right includeMethod: anObject ]
]

{ #category : #printing }
GtSearchMethodIntersectionFilter >> printOn: stream [
	left printOn: stream.
	stream nextPutAll: ' & '.
	right printOn: stream.
]
