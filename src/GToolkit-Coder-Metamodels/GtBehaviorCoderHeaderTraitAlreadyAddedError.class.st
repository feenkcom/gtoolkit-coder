Class {
	#name : #GtBehaviorCoderHeaderTraitAlreadyAddedError,
	#superclass : #GtBehaviorCoderHeaderTraitError,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderTraitAlreadyAddedError >> description [
	^ 'Trait named {1} already exists in the definition' format: { self traitName }
]
