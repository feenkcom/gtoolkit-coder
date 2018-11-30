Class {
	#name : #GtCoderIntersectionFilter,
	#superclass : #GtCoderBinaryFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #printing }
GtCoderIntersectionFilter >> gtDisplayOn: stream [
	<gtExample>
	left gtDisplayOn: stream.
	stream nextPutAll: ' & '.
	right gtDisplayOn: stream.
]

{ #category : #testing }
GtCoderIntersectionFilter >> includeMethod: aCompiledMethod [
	^ (left includeMethod: aCompiledMethod) and: [ right includeMethod: aCompiledMethod ]
]

{ #category : #printing }
GtCoderIntersectionFilter >> printOn: stream [
	<gtExample>
	left printOn: stream.
	stream nextPutAll: ' & '.
	right printOn: stream.
]
