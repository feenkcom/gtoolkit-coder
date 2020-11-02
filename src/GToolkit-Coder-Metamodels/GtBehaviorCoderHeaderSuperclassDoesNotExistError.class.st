Class {
	#name : #GtBehaviorCoderHeaderSuperclassDoesNotExistError,
	#superclass : #GtBehaviorCoderHeaderSuperclassError,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderSuperclassDoesNotExistError >> description [
	^ 'Superclass named {1} does not exist in the environment' format: { self superclassName }
]
