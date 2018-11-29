Class {
	#name : #GtCoderUnionFilter,
	#superclass : #GtCoderBinaryFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #printing }
GtCoderUnionFilter >> gtDisplayOn: stream [
	<gtExample>
	left gtDisplayOn: stream.
	stream nextPutAll: ' or '.
	right gtDisplayOn: stream.

]

{ #category : #testing }
GtCoderUnionFilter >> includeMethod: aCompiledMethod [
	^ (left includeMethod: aCompiledMethod) or: [ right includeMethod: aCompiledMethod ]
]
