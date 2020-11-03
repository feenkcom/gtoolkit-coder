Class {
	#name : #GtBehaviorCoderHeaderPoolAlreadyAddedError,
	#superclass : #GtBehaviorCoderHeaderPoolError,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderPoolAlreadyAddedError >> description [
	^ 'Pool named {1} already exists in the definition' format: { self poolName }
]
