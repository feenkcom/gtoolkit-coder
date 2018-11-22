Class {
	#name : #GtMethodsCoderFilterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #accessing }
GtMethodsCoderFilterExamples >> negatedReferencesToSampleB [
	<gtExample>
	| filter |
	filter := self referencesToSampleB not.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #methodReferencingSampleB) not.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #anotherMethodReferencingSampleB) not.
]

{ #category : #accessing }
GtMethodsCoderFilterExamples >> referencesToSampleB [
	<gtExample>
	| filter |
	filter := (self class environment at: #GtFilterStubSampleB) gtReferences.
	self assert: filter size = 2.
	self assert: (filter includeMethod: GtFilterStubSampleA >> #methodReferencingSampleB).
	self assert: (filter includeMethod: GtFilterStubSampleA >> #anotherMethodReferencingSampleB).
	^ filter
]
