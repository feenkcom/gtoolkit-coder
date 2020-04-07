Class {
	#name : #GtBehaviorCoderHeaderPoolAlreadyAddedError,
	#superclass : #GtBehaviorCoderHeaderPoolError,
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderPoolAlreadyAddedError >> description [
	^ 'Pool named {1} already exists in the definition' format: { self poolName }
]
