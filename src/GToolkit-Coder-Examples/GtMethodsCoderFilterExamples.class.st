Class {
	#name : #GtMethodsCoderFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #accessing }
GtMethodsCoderFilterExamples >> gtExamplePragmas [
	<gtExample>
	| filter |
	filter := #gtExample gtPragmas.
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
	self assert: filter size = 1.
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
GtMethodsCoderFilterExamples >> referencesToSampleB [
	<gtExample>
	| filter |
	filter := GtFilterStubSampleB gtReferences.
	self assert: filter size = 3.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #methodReferencingSampleB).
	self assert: (filter includeMethod: GtFilterStubSampleA >> #anotherMethodReferencingSampleBAndSendingNew).
	^ filter
]
