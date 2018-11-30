Class {
	#name : #GtCoderUnionFilter,
	#superclass : #GtCoderBinaryFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #printing }
GtCoderUnionFilter >> gtDisplayOn: stream [
	<gtExample>
	left gtDisplayOn: stream.
	stream nextPutAll: ' | '.
	right gtDisplayOn: stream.

]

{ #category : #testing }
GtCoderUnionFilter >> includeMethod: aCompiledMethod [
	^ (left includeMethod: aCompiledMethod) or: [ right includeMethod: aCompiledMethod ]
]

{ #category : #printing }
GtCoderUnionFilter >> printOn: stream [
	<gtExample>
	left printOn: stream.
	stream nextPutAll: ' | '.
	right printOn: stream.

]
