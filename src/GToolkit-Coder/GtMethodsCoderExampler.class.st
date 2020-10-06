"
I am an example executor.
I am used by ${class:GtMethodsCoder}$, see: ${method:Behavior>>#gtCoderMethodsFor:context:}$ for a usage.
"
Class {
	#name : #GtMethodsCoderExampler,
	#superclass : #GtCoderExampler,
	#category : #'GToolkit-Coder-Exampler'
}

{ #category : #'api - accessing' }
GtMethodsCoderExampler >> coderFor: aCompiledMethod [
	<return: #GtMethodCoder>
	^ self coder coderFor: aCompiledMethod
]

{ #category : #'private - accessing' }
GtMethodsCoderExampler >> exampleCodersDo: aBlock [
	self coder coders do: [ :eachCoder | 
		eachCoder example ifNotNil: [ 
			aBlock cull: eachCoder ] ]
]
