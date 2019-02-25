"
!Filter examples

!!Implementors

${example:GtMethodsCoderFilterExamples>>#implementorsOfThisMessage}$

!!Package pattern

${example:GtMethodsCoderFilterExamples>>#packagePatternFilter}$

!!Pragmas

${example:GtMethodsCoderExamples>>#gtExamplesFilter}$


!!References

==gtReferences== can be applied to several objects. 

Class references:
${example:GtMethodsCoderFilterExamples>>#referencesToSampleB|previewShow=gtItemsFor:}$

Selector references:
${example:GtMethodsCoderFilterExamples>>#referencesToThisSelector}$

Number references
${example:GtMethodsCoderFilterExamples>>#referencesTo42}$

!!Intersection

${example:GtMethodsCoderFilterExamples>>#gtExamplePragmasAndReferencesToMethodCoder}$

!!Union

@@todo



"
Class {
	#name : #GtSearchMethodFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #accessing }
GtSearchMethodFilterExamples >> astPatternFilter [
	<gtExample>
	| filter |
	filter := 'filter matches: ``@a' gtASTMatches.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> gtExamplePragmas [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> gtExamplePragmasAndReferencesToMethodCoder [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas & GtMethodCoder gtReferences.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> gtExamplePragmasAndReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self gtExamplePragmas & self referencesToSampleB.
	self assert: filter notEmpty.
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> implementorsOfThisMessage [
	<gtExample>
	| filter |
	filter := #implementorsOfThisMessage gtImplementors.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> negatedReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self referencesToSampleB not.
	self assert: (filter matches: GtFilterStubSampleA >> #methodReferencingSampleB) not.
	self assert: (filter matches: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew) not.
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> packagePatternFilter [
	<gtExample>
	| filter |
	filter := 'coder-examples' gtPackageMatches.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesTo42 [
	<gtExample>
	| filter |
	filter := 42 gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencing42).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToArray [
	<gtExample>
	| filter |
	filter := #(4 2) gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingArray).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToByteArray [
	<gtExample>
	| filter |
	filter := #[ 4 2 ] gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingByteArray).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToCharacter [
	<gtExample>
	| filter |
	filter := $c gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingCharacter).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToFalse [
	<gtExample>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToNil [
	<gtExample>
	| filter |
	filter := nil gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingNil).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToSampleB [
	<gtExample>
	| filter |
	filter := GtFilterStubSampleB gtReferences.
	self assert: filter notEmpty.
	self assert: (filter matches: GtFilterStubSampleA >> #methodReferencingSampleB).
	self assert: (filter matches: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToString [
	<gtExample>
	| filter |
	filter := 'string' gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingString).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToThisSelector [
	<gtExample>
	| filter |
	filter := #referencesToThisSelector gtReferences.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #accessing }
GtSearchMethodFilterExamples >> referencesToTrue [
	<gtExample>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]
