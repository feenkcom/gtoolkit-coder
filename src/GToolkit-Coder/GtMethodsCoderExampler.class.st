"
I am an example executor.
I am used by ${class:GtMethodsCoder}$, see: ${method:Behavior>>#gtCoderMethodsFor:context:}$ for a usage.
"
Class {
	#name : #GtMethodsCoderExampler,
	#superclass : #GtCoderExampler,
	#category : #'GToolkit-Coder-Exampler'
}

{ #category : #'private - accessing' }
GtMethodsCoderExampler >> exampleCoders [
	^ self coder coders select: [ :eachCoder | 
			eachCoder canExecuteExample ]
]
