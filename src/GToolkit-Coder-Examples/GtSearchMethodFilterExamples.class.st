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

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesTo42 [
	<gtExample>
	| filter |
	filter := 42 gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencing42).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToArray [
	<gtExample>
	| filter |
	filter := #(4 2) gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingArray).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToByteArray [
	<gtExample>
	| filter |
	filter := #[ 4 2 ] gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingByteArray).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToCharacter [
	<gtExample>
	| filter |
	filter := $c gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingCharacter).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToFalse [
	<gtExample>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToNil [
	<gtExample>
	| filter |
	filter := nil gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingNil).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToSampleB [
	<gtExample>
	| filter |
	filter := GtFilterStubSampleB gtReferences.
	self assert: filter notEmpty.
	self assert: (filter matches: GtFilterStubSampleA >> #methodReferencingSampleB).
	self assert: (filter matches: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToString [
	<gtExample>
	| filter |
	filter := 'string' gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingString).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToThisSelector [
	<gtExample>
	| filter |
	filter := #referencesToThisSelector gtReferences.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #examples }
GtSearchMethodFilterExamples >> referencesToTrue [
	<gtExample>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]
