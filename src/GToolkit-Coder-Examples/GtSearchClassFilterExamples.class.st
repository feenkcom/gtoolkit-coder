Class {
	#name : #GtSearchClassFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #assertions }
GtSearchClassFilterExamples >> assertClassResultTypeForFilter: aFilter [
	self assert: aFilter resultType equals: GtSearchClassGroupResult.
]

{ #category : #examples }
GtSearchClassFilterExamples >> classesInCurrentPackageFilter [
	<gtExample>
	| filter |
	filter := GtSearchClassesInPackageFilter forPackageNamed: 'GToolkit-Coder-Examples-SystemS1'.
	
	self assert: (filter matches: GtSystemS1SubclassC2).
	self assert: (filter matches: Object) not.
	
	^ filter
	
]

{ #category : #'examples - equality' }
GtSearchClassFilterExamples >> classesInCurrentPackageFilterEquality [
	<gtExample>
	| filter |
	filter := self classesInCurrentPackageFilter.
	self assert: filter equals: filter.
	self 
		assert: filter
		equals: (GtSearchClassesInPackageFilter forPackageNamed: 'GToolkit-Coder-Examples-SystemS1').
	^ filter
	
]

{ #category : #'examples - result type' }
GtSearchClassFilterExamples >> classesInCurrentPackageFilterResultType [
	<gtExample>
	| filter |
	filter := self classesInCurrentPackageFilter.
	self assert: filter defaultFilterScope == filter.
	self assertClassResultTypeForFilter: filter.
	^ filter
	
]

{ #category : #examples }
GtSearchClassFilterExamples >> classesInImageFilter [
	<gtExample>
	| filter |
	filter := GtSearchImageClassesFilter new.
	
	self assert: (filter matches: GtSystemS1SubclassC2).
	self assert: (filter matches: Object).
	
	^ filter
	
]

{ #category : #'examples - equality' }
GtSearchClassFilterExamples >> classesInImageFilterEquality [
	<gtExample>
	| filter |
	filter := self classesInImageFilter.
	self assert: filter equals: filter.
	self assert: filter equals: GtSearchImageClassesFilter new.
	^ filter
	
]

{ #category : #'examples - result type' }
GtSearchClassFilterExamples >> classesInImageFilterResultType [
	<gtExample>
	| filter |
	filter := self classesInImageFilter.
	self assert: filter defaultFilterScope == filter.
	self assertClassResultTypeForFilter: filter.
	^ filter
	
]

{ #category : #examples }
GtSearchClassFilterExamples >> deprecatedClassesFilter [
	<gtExample>
	| filter |
	filter := GtSearchDeprecatedClassesFilter new.
	self assert: (filter matches: GtSystemS1AnotherClassC3).
	self assert: (filter matches: GtSystemS1RootClassC1) not.
	^ filter
	
]

{ #category : #'examples - result type' }
GtSearchClassFilterExamples >> deprecatedClassesFilterResultType [
	<gtExample>
	| filter |
	filter := self deprecatedClassesFilter.
	self assert: filter defaultFilterScope equals: GtSearchImageClassesFilter new.
	self assertClassResultTypeForFilter: filter.
	^ filter
	
]

{ #category : #examples }
GtSearchClassFilterExamples >> deprecatedClassesInPackageScopeFilter [
	<gtExample>
	"Use an intersection filter that uses the package filter as the first filter in the intersection."
	| filter |
	filter := GtSearchIntersectionFilter new
		filter: self classesInCurrentPackageFilter
		filter: GtSearchDeprecatedClassesFilter new.
	
	self assert: (filter matches: GtSystemS1AnotherClassC3).
	self assert: (filter matches: GtSystemS1RootClassC1) not.
	
	self assert: filter defaultFilterScope == filter leftFilter.
	self assertClassResultTypeForFilter: filter.
	
	^ filter
	
]

{ #category : #examples }
GtSearchClassFilterExamples >> deprecatedClassesInPackageUsingImageScopeFilter [
	<gtExample>
	"Start first with the deprecated filter. This has as scope the entire image."
	| filter |
	filter := GtSearchIntersectionFilter new
		filter: GtSearchDeprecatedClassesFilter new
		filter: self classesInCurrentPackageFilter.
	
	self assert: (filter matches: GtSystemS1AnotherClassC3).
	self assert: (filter matches: GtSystemS1RootClassC1) not.
	self assert: filter result size equals: 1.
	
	self assert: filter defaultFilterScope equals: GtSearchImageClassesFilter new.
	self assertClassResultTypeForFilter: filter.
	
	^ filter
	
]

{ #category : #'examples - result' }
GtSearchClassFilterExamples >> groupResultForClassesInImageFilter [
	<gtExample>
	<noTest>
	| filter result |
	filter := self classesInImageFilter.
	result := filter result.
	
	self assert: result class equals: GtSearchClassGroupResult.
	self assert: result filter equals: filter.
	self assert: result scope == filter.
	self assert: result size equals: Smalltalk allClassesAndTraits size.
	self assert: (result includes: GtSystemS1SubclassC2).
	self assert: (result includes: Object).
	
	^ result
]

{ #category : #'examples - result' }
GtSearchClassFilterExamples >> groupResultForClassesInPackageFilter [
	<gtExample>
	| filter result |
	filter := self classesInCurrentPackageFilter.
	result := filter result.
	
	self assert: result class equals: GtSearchClassGroupResult.
	self assert: result filter equals: filter.
	self assert: result scope == filter.
	self assert: result size equals: 5.
	self assert: (result includes: GtSystemS1SubclassC2).
	self assert: (result includes: Object) not.
	
	^ result
]

{ #category : #'examples - result' }
GtSearchClassFilterExamples >> groupResultForDeprecatedClassesInPackageScopeFilter [
	<gtExample>
	| filter result |
	filter := self deprecatedClassesInPackageScopeFilter.
	result := filter result.
	
	self assert: result class equals: GtSearchClassGroupResult.
	self assert: result filter equals: filter.
	self assert: result scope == filter leftFilter.
	self assert: result size equals: 1.
	self assert: (result includes: GtSystemS1AnotherClassC3).
	self assert: (result includes: GtSystemS1RootClassC1) not.
	
	^ result
]

{ #category : #examples }
GtSearchClassFilterExamples >> testClassesFilter [
	<gtExample>
	| filter |
	filter := GtSearchTestClassesFilter new.
	
	self assert: (filter matches: BlockClosureTest).
	self assert: (filter matches: ArrayTest).
	
	^ filter
	
]

{ #category : #examples }
GtSearchClassFilterExamples >> testClassesFilterInPackage [
	<gtExample>
	| filter |
	
	filter := GtSearchIntersectionFilter new
		filter: GtSearchTestClassesFilter new
		filter: (GtSearchClassesInPackageFilter forPackageNamed: 'Kernel-Tests').
	
	self assert: (filter matches: BlockClosureTest).
	self assert: (filter matches: ArrayTest) not.
	
	^ filter
	
]
