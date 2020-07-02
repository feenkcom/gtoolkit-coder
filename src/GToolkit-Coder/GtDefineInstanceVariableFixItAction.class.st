Class {
	#name : #GtDefineInstanceVariableFixItAction,
	#superclass : #GtFixItAction,
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> description [
	^ 'Add instance variable ' , node name , ' to class '
		, methodCoder classOrMetaClass name
]

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> execute [
	| refactoring |
	refactoring := RBAddInstanceVariableRefactoring
		variable: node name
		class: methodCoder classOrMetaClass.
	refactoring execute
]
