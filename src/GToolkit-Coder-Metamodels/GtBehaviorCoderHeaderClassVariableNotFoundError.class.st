Class {
	#name : #GtBehaviorCoderHeaderClassVariableNotFoundError,
	#superclass : #GtBehaviorCoderHeaderClassVariableError,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassVariableNotFoundError >> description [
	^ 'Class variable named {1} is not found in the definition' format: { self variableName }
]
