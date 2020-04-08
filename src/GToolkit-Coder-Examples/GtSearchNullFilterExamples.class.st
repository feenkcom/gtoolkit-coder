Class {
	#name : #GtSearchNullFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'as yet unclassified' }
GtSearchNullFilterExamples >> nullSearchFilter [
	<gtExample>
	| filter |
	filter := GtSearchNullFilter new.
	
	self assert: (filter matches: thisContext method) not.
	self assert: (filter matches: 'GToolkit-Coder' asPackage) not.
	self assert: (filter isEmpty).
	
	^ filter.
]
