Class {
	#name : #GtSearchMethodUnionFilter,
	#superclass : #GtSearchBinaryMethodFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #printing }
GtSearchMethodUnionFilter >> gtDisplayOn: stream [
	left gtDisplayOn: stream.
	stream nextPutAll: ' | '.
	right gtDisplayOn: stream.

]

{ #category : #testing }
GtSearchMethodUnionFilter >> includeMethod: anObject [
	^ (left includeMethod: anObject) or: [ right includeMethod: anObject ]
]

{ #category : #printing }
GtSearchMethodUnionFilter >> printOn: stream [
	left printOn: stream.
	stream nextPutAll: ' | '.
	right printOn: stream.

]
