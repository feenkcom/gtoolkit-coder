Class {
	#name : #GtCoderIntersectionFilter,
	#superclass : #GtCoderBinaryFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #testing }
GtCoderIntersectionFilter >> includeMethod: aCompiledMethod [
	^ (left includeMethod: aCompiledMethod) and: [ right includeMethod: aCompiledMethod ]
]
