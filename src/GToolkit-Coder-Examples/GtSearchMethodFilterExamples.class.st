"
!Method filter examples

!!Implementors

${example:GtSearchMethodFilterExamples>>#implementorsOfThisMessage}$

!!Package pattern

${example:GtSearchMethodFilterExamples>>#packagePatternFilter}$

!!Pragmas

${example:GtMethodsCoderExamples>>#gtExamplesFilter}$


!!References

==gtReferences== can be applied to several objects. 

Class references:
${example:GtSearchMethodReferencesFilterExamples>>#referencesToSampleB|previewShow=gtItemsFor:}$

Selector references:
${example:GtSearchMethodReferencesFilterExamples>>#referencesToThisSelector}$

Number references
${example:GtSearchMethodReferencesFilterExamples>>#referencesTo42}$

!!Intersection

${example:GtSearchMethodReferencesFilterExamples>>#gtExamplePragmasAndReferencesToMethodCoder}$

!!Union

@@todo



"
Class {
	#name : #GtSearchMethodFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #asserting }
GtSearchMethodFilterExamples >> assertMethodResultTypeForFilter: aFilter [
	self assert: aFilter resultType equals: GtSearchMethodGroupResult.
]

{ #category : #examples }
GtSearchMethodFilterExamples >> astPatternFilter [
	<gtExample>
	| filter |
	filter := 'filter matches: ``@a' gtASTMatches.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #'as yet unclassified' }
GtSearchMethodFilterExamples >> deprecatedMethodsFilter [
	<gtExample>
	| filter |
	
	filter := GtSearchDeprecatedMethodsFilter new.
	
	self assert: (filter matches: BlElement>>#managed).
	self assert: (filter matches: BlElement>>#margin) not.
	
	^ filter.
]

{ #category : #examples }
GtSearchMethodFilterExamples >> gtExamplePragmas [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> implementorsOfThisMessage [
	<gtExample>
	| filter |
	filter := #implementorsOfThisMessage gtImplementors.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #'as yet unclassified' }
GtSearchMethodFilterExamples >> implementorsPatternFilter [
	<gtExample>
	| filter |
	filter := GtSearchImplementorPatternFilter pattern: #implementorsPattern.
	
	self assert: (filter matches: thisContext method).
	
	^ filter.
]

{ #category : #'examples - method conditions' }
GtSearchMethodFilterExamples >> methodConditionsFilter_Default [
	<gtExample>
	| filter |
	
	filter := GtSearchMethodConditionsFilter new.
	"By default all methods satisfy the filter"
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#conditions).
	
	^ filter.
]

{ #category : #'examples - method conditions' }
GtSearchMethodFilterExamples >> methodConditionsFilter_OneCondition [
	<gtExample>
	| filter |
	
	filter := GtSearchMethodConditionsFilter 
		condition: [ :aMethod | aMethod numArgs isZero ].
	
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#conditions).
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#condition:) not.
	
	^ filter.
]

{ #category : #'examples - method conditions' }
GtSearchMethodFilterExamples >> methodConditionsFilter_SubclassRerence [
	<gtExample>
	| filter |
	
	filter := GtSearchMethodConditionsFilter new
		referenceSubclass: OrderedCollection.
	
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#initialize).
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#condition:) not.
	
	^ filter.
]

{ #category : #'examples - method conditions' }
GtSearchMethodFilterExamples >> methodConditionsFilter_TwoConditions [
	<gtExample>
	| filter |
	
	filter := GtSearchMethodConditionsFilter new 
		condition: [ :aMethod | aMethod numArgs = 1 ];
		condition: [ :aMethod | aMethod protocol = 'api - accessing' ].
	
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#condition:).
	self assert: (filter matches: GtSearchMethodConditionsFilter>>#conditions) not.
	
	^ filter.
]

{ #category : #examples }
GtSearchMethodFilterExamples >> methodsInCategoryFilter [
	<gtExample>
	| filter |
	filter := GtSearchMethodCategoryFilter forCategory: 'examples'.
	
	self assert: (filter matches: thisContext method).
	
	^ filter.
]

{ #category : #'as yet unclassified' }
GtSearchMethodFilterExamples >> methodsInPackageFilter [
	<gtExample>
	| filter |
	
	filter := GtSearchMethodsInPackageFilter new package: ('GToolkit-Coder-Examples' asPackage).
	
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	
	^ filter.
]

{ #category : #'as yet unclassified' }
GtSearchMethodFilterExamples >> methodsWithClassPatternFilter [
	<gtExample>
	| filter |
	filter := GtSearchMethodsWithClassPatternFilter pattern: #FilterExamples.
	
	self assert: (filter matches: thisContext method).
	
	^ filter.
]

{ #category : #examples }
GtSearchMethodFilterExamples >> packagePatternFilter [
	<gtExample>
	| filter |
	filter := 'coder-examples' gtPackageMatches.
	self assert: (filter matches: thisContext method).
	^ filter
]
