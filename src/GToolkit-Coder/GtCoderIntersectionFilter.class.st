Class {
	#name : #GtCoderIntersectionFilter,
	#superclass : #GtCoderBinaryFilter,
	#category : #'GToolkit-Coder'
}

{ #category : #testing }
GtCoderIntersectionFilter >> includeMethod: aCompiledMethod [
	^ (left includeMethod: aCompiledMethod) and: [ right includeMethod: aCompiledMethod ]
]
