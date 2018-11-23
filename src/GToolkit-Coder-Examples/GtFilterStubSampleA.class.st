Class {
	#name : #GtFilterStubSampleA,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #samples }
GtFilterStubSampleA >> anotherMethodReferencingSampleBAndSendingNew [
	^ GtFilterStubSampleB new
]

{ #category : #samples }
GtFilterStubSampleA >> methodReferencingSampleB [
	^ GtFilterStubSampleB
]
