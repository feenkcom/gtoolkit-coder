Class {
	#name : #GtSearchNullFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #'as yet unclassified' }
GtSearchNullFilterExamples >> nullSearchFilter [
	<gtExample>
	<return: #GtSearchNullFilter>
	| filter |
	filter := GtSearchNullFilter new.

	self assert: (filter matches: thisContext method) not.
	self assert: (filter matches: 'GToolkit-Coder' asPackage) not.
	self assert: filter isEmpty.

	^ filter
]
