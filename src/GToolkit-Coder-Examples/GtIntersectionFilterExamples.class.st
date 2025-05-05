Class {
	#name : #GtIntersectionFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #'as yet unclassified' }
GtIntersectionFilterExamples >> intersectionDifferentFilters [
	<gtExample>
	<return: #GtSearchIntersectionFilter>
	| filter1 filter2 intersection |
	filter1 := #gtExample gtPragmas.
	filter2 := #filter gtReferences.
	intersection := filter1 & filter2.
	self assert: (intersection matches: thisContext method).
	^ intersection
]

{ #category : #'as yet unclassified' }
GtIntersectionFilterExamples >> intersectionSameFilter [
	<gtExample>
	<return: #GtSearchIntersectionFilter>
	| filter intersection |
	filter := #gtExample gtPragmas.
	intersection := filter & filter.

	self assert: intersection size equals: filter size.
	self assert: (intersection matches: thisContext method).

	^ intersection
]
