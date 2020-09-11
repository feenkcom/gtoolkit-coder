Class {
	#name : #GtFilterStubSampleA,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #samples }
GtFilterStubSampleA >> anotherMethodReferencingSampleBAndSendingNew [
	^ GtFilterStubSampleB new
]

{ #category : #samples }
GtFilterStubSampleA >> methodReferencingSampleB [
	^ GtFilterStubSampleB
]
