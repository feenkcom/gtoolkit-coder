Class {
	#name : #GtSearchNegationFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'as yet unclassified' }
GtSearchNegationFilterExamples >> negationSearchFilter [
	<gtExample>
	| basicFilter negationFilter |
	basicFilter := GtSearchDeprecatedPackagesFilter new.
	negationFilter := basicFilter not.
	
	self assert: (negationFilter notEmpty).
	self assert: (negationFilter matches: 'GToolkit-Coder-Examples' asPackage).
	
	^ negationFilter.
]

{ #category : #'as yet unclassified' }
GtSearchNegationFilterExamples >> negationSearchFilterExplicitDefinition [
	<gtExample>
	| basicFilter negationFilter |
	basicFilter := GtSearchDeprecatedPackagesFilter new.
	negationFilter := GtSearchNegationFilter new
		originalFilter: basicFilter.
	
	self assert: (negationFilter notEmpty).
	self assert: (negationFilter matches: 'GToolkit-Coder' asPackage).
	
	^ negationFilter.
]
