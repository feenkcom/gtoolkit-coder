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
${example:GtSearchMethodFilterExamples>>#referencesToSampleB|previewShow=gtItemsFor:}$

Selector references:
${example:GtSearchMethodFilterExamples>>#referencesToThisSelector}$

Number references
${example:GtSearchMethodFilterExamples>>#referencesTo42}$

!!Intersection

${example:GtSearchMethodFilterExamples>>#gtExamplePragmasAndReferencesToMethodCoder}$

!!Union

@@todo



"
Class {
	#name : #GtSearchMethodFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtSearchMethodFilterExamples >> astPatternFilter [
	<gtExample>
	| filter |
	filter := 'filter matches: ``@a' gtASTMatches.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
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
GtSearchMethodFilterExamples >> gtExamplePragmasAndReferencesToMethodCoder [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas & GtMethodCoder gtReferences.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> gtExamplePragmasAndReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self gtExamplePragmas & self referencesToSampleB.
	self assert: filter notEmpty.
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

{ #category : #examples }
GtSearchMethodFilterExamples >> negatedReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self referencesToSampleB not.
	self assert: (filter matches: GtFilterStubSampleA >> #methodReferencingSampleB) not.
	self assert: (filter matches: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew) not.
]

{ #category : #examples }
GtSearchMethodFilterExamples >> packagePatternFilter [
	<gtExample>
	| filter |
	filter := 'coder-examples' gtPackageMatches.
	self assert: (filter matches: thisContext method).
	^ filter
]
