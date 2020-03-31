Class {
	#name : #GtBehaviorCoderHeaderTraitDoesNotExistError,
	#superclass : #GtBehaviorCoderHeaderTraitError,
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderTraitDoesNotExistError >> description [
	^ 'Trait named {1} does not exist in the environment' format: { self traitName }
]
