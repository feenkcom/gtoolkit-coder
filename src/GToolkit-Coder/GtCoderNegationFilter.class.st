Class {
	#name : #GtCoderNegationFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'originalFilter'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #printing }
GtCoderNegationFilter >> gtDisplayOn: stream [
	<gtExample>
	self originalFilter gtDisplayOn: stream.
	stream nextPutAll: ' not'
]

{ #category : #testing }
GtCoderNegationFilter >> includeMethod: aCompiledMethod [
	^ (self originalFilter includeMethod: aCompiledMethod) not
]

{ #category : #accessing }
GtCoderNegationFilter >> originalFilter [
	^ originalFilter
]

{ #category : #accessing }
GtCoderNegationFilter >> originalFilter: anObject [
	originalFilter := anObject
]

{ #category : #printing }
GtCoderNegationFilter >> printOn: stream [
	<gtExample>
	self originalFilter printOn: stream.
	stream nextPutAll: ' not'
]
