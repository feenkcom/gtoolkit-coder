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
	#category : #'GToolkit-Coder-Examples'
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

{ #category : #examples }
GtSearchMethodFilterExamples >> methodsInCategoryFilter [
	<gtExample>
	| filter |
	filter := GtSearchMethodCategoryFilter forCategory: 'examples'.
	
	self assert: (filter matches: thisContext method).
	
	^ filter.
]

{ #category : #'as yet unclassified' }
GtSearchMethodFilterExamples >> methodsInImageFilter [
	<gtExample>
	| filter |
	
	filter := GtSearchImageMethodsFilter new.
	
	self assert: (filter matches: self class>>#methodsInImageFilter).
	
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
