"
I am an example executor.
I am used by ${class:GtMethodsCoder}$, see: ${method:Behavior>>#gtCoderMethodsFor:context:}$ for a usage.
"
Class {
	#name : #GtMethodsCoderExampler,
	#superclass : #GtCoderExampler,
	#category : #'GToolkit-Coder-Exampler'
}

{ #category : #'as yet unclassified' }
GtMethodsCoderExampler >> coderFor: aCompiledMethod [
	<return: #GtMethodCoder>
	^ self coder coderFor: aCompiledMethod
]

{ #category : #'private - accessing' }
GtMethodsCoderExampler >> exampleCodersDo: aBlock [
	^ self coder coders do: [ :eachCoder | 
			eachCoder canExecuteExample ifTrue: [ 
				aBlock cull: eachCoder ] ]
]
