"
I am an example executor.
I am used by {{gtClass:GtPharoMethodsCoder}}, see: {{gtMethod:Behavior>>#gtCoderMethodsFor:context:}} for a usage.


"
Class {
	#name : 'GtMethodsCoderExampler',
	#superclass : 'GtCoderExampler',
	#category : 'GToolkit-Coder-Exampler'
}

{ #category : 'api - enumeration' }
GtMethodsCoderExampler >> allExampleCodersDo: aBlock [
	self coder allCoders do: [ :eachCoder | 
		eachCoder example ifNotNil: [ :anExample |
			aBlock cull: eachCoder cull: anExample ] ]
]

{ #category : 'api - accessing' }
GtMethodsCoderExampler >> coderFor: aCompiledMethod [
	<return: #GtPharoMethodCoder>
	^ self coder coderFor: aCompiledMethod
]

{ #category : 'api - enumeration' }
GtMethodsCoderExampler >> selectedExampleCodersDo: aBlock [
	self coder coders do: [ :eachCoder | 
		eachCoder example ifNotNil: [ :anExample |
			aBlock cull: eachCoder cull: anExample ] ]
]
