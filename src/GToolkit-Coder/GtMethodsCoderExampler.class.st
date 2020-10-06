"
I am an example executor.
I am used by ${class:GtMethodsCoder}$, see: ${method:Behavior>>#gtCoderMethodsFor:context:}$ for a usage.
"
Class {
	#name : #GtMethodsCoderExampler,
	#superclass : #GtCoderExampler,
	#category : #'GToolkit-Coder-Exampler'
}

{ #category : #'private - enumeration' }
GtMethodsCoderExampler >> allExampleCodersDo: aBlock [
	self coder allCoders do: [ :eachCoder | 
		eachCoder example ifNotNil: [ 
			aBlock cull: eachCoder ] ]
]

{ #category : #'api - accessing' }
GtMethodsCoderExampler >> coderFor: aCompiledMethod [
	<return: #GtMethodCoder>
	^ self coder coderFor: aCompiledMethod
]

{ #category : #'private - accessing' }
GtMethodsCoderExampler >> selectedExampleCodersDo: aBlock [
	self coder coders do: [ :eachCoder | 
		eachCoder example ifNotNil: [ 
			aBlock cull: eachCoder ] ]
]
