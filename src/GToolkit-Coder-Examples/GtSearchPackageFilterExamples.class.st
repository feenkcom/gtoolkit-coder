Class {
	#name : #GtSearchPackageFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #asserting }
GtSearchPackageFilterExamples >> assertPackageResultTypeForFilter: aFilter [
	self assert: aFilter resultType equals: GtSearchPackageGroupResult.
]

{ #category : #'as yet unclassified' }
GtSearchPackageFilterExamples >> deprecatedPackagesFilter [
	<gtExample>
	| filter |
	
	filter := GtSearchDeprecatedPackagesFilter new.
	
	self assert: (filter matches: 'Deprecated80' asPackage).
	self assert: (filter matches: 'GToolkit-Docs' asPackage) not.
	
	^ filter.
]

{ #category : #'examples - result' }
GtSearchPackageFilterExamples >> groupResultForPackagesInImageFilter [
	<gtExample>
	| filter result |
	filter := self packagesInImageFilter.
	result := filter result.
	
	self assert: (result isKindOf: GtSearchPackageGroupResult).
	self assert: result filter equals: filter.
	self assert: result scope == filter.
	self assert: result size equals: RPackage organizer packages size.
	self assert: (result includes: 'GToolkit-Coder-Examples' asPackage).
	self assert: (result includes: (RPackage named: 'A-Package-ThatDoesNotExist')) not.
	
	^ result
]

{ #category : #examples }
GtSearchPackageFilterExamples >> packagesInImageFilter [
	<gtExample>
	| filter |
	filter := GtSearchImagePackagesFilter new.
	
	self assert: (filter matches: 'GToolkit-Coder-Examples' asPackage).
	self assert: (filter matches: (RPackage named: 'A-Package-ThatDoesNotExist')) not.
	
	self assert: filter defaultFilterScope == filter.
	self assertPackageResultTypeForFilter: filter.
	
	^ filter
]

{ #category : #examples }
GtSearchPackageFilterExamples >> packagesInImageFilterEqualityExample [
	<gtExample>
	| filter |
	filter := self packagesInImageFilter.
	self 
		assert: filter
		equals:  GtSearchImagePackagesFilter new.
	^ filter
]
