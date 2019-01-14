Class {
	#name : #GtMethodsCoderFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #accessing }
GtMethodsCoderFilterExamples >> astPatternFilter [
	<gtExample>
	| filter |
	filter := 'filter includeMethod: ``@a' gtASTMatches.
	self assert: filter notEmpty.
	self assert: (filter includeMethod: thisContext method).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> gtExamplePragmas [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas.
	self assert: filter notEmpty.
	self assert: (filter includeMethod: thisContext method).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> gtExamplePragmasAndReferencesToMethodCoder [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas & GtMethodCoder gtReferences.
	self assert: (filter includeMethod: thisContext method).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> gtExamplePragmasAndReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self gtExamplePragmas & self referencesToSampleB.
	self assert: filter notEmpty.
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> negatedReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self referencesToSampleB not.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #methodReferencingSampleB) not.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew) not.
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> packagePatternFilter [
	<gtExample>
	| filter |
	filter := 'coder-examples' gtPackageMatches.
	self assert: (filter includeMethod: thisContext method).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesTo42 [
	<gtExample>
	| filter |
	filter := 42 gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter includeMethod: GtFilterStubSampleB >> #methodReferencing42).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesToCharacter [
	<gtExample>
	| filter |
	filter := $c gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter includeMethod: GtFilterStubSampleB >> #methodReferencingCharacter).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesToFalse [
	<gtExample>
	<noTest>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter includeMethod: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesToSampleB [
	<gtExample>
	| filter |
	filter := GtFilterStubSampleB gtReferences.
	self assert: filter notEmpty.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #methodReferencingSampleB).
	self assert: (filter includeMethod: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesToString [
	<gtExample>
	| filter |
	filter := 'string' gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter includeMethod: GtFilterStubSampleB >> #methodReferencingString).
	^ filter
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesToTrue [
	<gtExample>
	<noTest>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter includeMethod: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]
