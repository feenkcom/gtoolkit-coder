Class {
	#name : #GtBehaviorCoderHeaderPoolDoesNotExistError,
	#superclass : #GtBehaviorCoderHeaderPoolError,
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderPoolDoesNotExistError >> description [
	^ 'Pool named {1} does not exist in the environment' format: { self poolName }
]
