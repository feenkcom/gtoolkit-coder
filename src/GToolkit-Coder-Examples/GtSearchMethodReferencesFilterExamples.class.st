Class {
	#name : #GtSearchMethodReferencesFilterExamples,
	#superclass : #GtSearchMethodFilterExamples,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> gtExamplePragmasAndReferencesToMethodCoder [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas & GtPharoMethodCoder gtReferences.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> gtExamplePragmasAndReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self gtExamplePragmas & self referencesToSampleB.
	self assert: filter notEmpty.
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> negatedReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self referencesToSampleB not.
	self assert: (filter matches: GtFilterStubSampleA >> #methodReferencingSampleB) not.
	self assert: (filter matches: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew) not.
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesTo42 [
	<gtExample>
	| filter |
	filter := 42 gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencing42).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToArray [
	<gtExample>
	| filter |
	filter := #(4 2) gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingArray).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToByteArray [
	<gtExample>
	| filter |
	filter := #[ 4 2 ] gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingByteArray).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToCharacter [
	<gtExample>
	| filter |
	filter := $c gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingCharacter).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToFalse [
	<gtExample>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToNil [
	<gtExample>
	| filter |
	filter := nil gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingNil).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToSampleB [
	<gtExample>
	| filter |
	filter := GtFilterStubSampleB gtReferences.
	self assert: filter notEmpty.
	self assert: (filter matches: GtFilterStubSampleA >> #methodReferencingSampleB).
	self assert: (filter matches: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToString [
	<gtExample>
	| filter |
	filter := 'string' gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingString).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToThisSelector [
	<gtExample>
	| filter |
	filter := #referencesToThisSelector gtReferences.
	self assert: filter notEmpty.
	self assert: (filter matches: thisContext method).
	^ filter
]

{ #category : #examples }
GtSearchMethodReferencesFilterExamples >> referencesToTrue [
	<gtExample>
	| filter |
	filter := true gtReferences.
	self assert: filter isEmpty not.
	self assert: (filter matches: GtFilterStubSampleB >> #methodReferencingTrue).
	^ filter
]
