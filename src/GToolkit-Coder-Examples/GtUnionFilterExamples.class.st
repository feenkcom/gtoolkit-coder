Class {
	#name : #GtUnionFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtUnionFilterExamples >> unionDifferentMethods [
	<gtExample>
	| filter1 filter2 union |
	filter1 := thisContext method selector gtImplementors.
	filter2 := #foo gtImplementors.
	union := filter1 | filter2.
	self assert: union size = (filter1 size + filter2 size).
	self assert: (union matches: thisContext method).
	^ union
]

{ #category : #examples }
GtUnionFilterExamples >> unionNullFilter [
	<gtExample>
	<noTest>
	| filter union |
	filter := thisContext method selector gtImplementors.
	union := GtSearchNullFilter new | filter | filter.
	self assert: union size equals: filter size.
	self assert: (union matches: thisContext method).
	^ union
]

{ #category : #examples }
GtUnionFilterExamples >> unionSameFilters [
	<gtExample>
	| filter union |
	filter := thisContext method selector gtImplementors.
	union := filter | filter.
	self assert: union size = filter size.
	self assert: (union matches: thisContext method).
	^ union
]
