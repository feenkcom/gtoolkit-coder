Class {
	#name : #GtBehaviorCoderHeaderSuperclassNotApplicableError,
	#superclass : #GtBehaviorCoderHeaderSuperclassError,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderSuperclassNotApplicableError >> description [
	^ 'Class named {1} can not be used as a superclass' format: { self superclassName }
]
