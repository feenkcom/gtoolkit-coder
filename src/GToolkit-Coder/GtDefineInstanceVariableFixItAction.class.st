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
	methodCoder addInstanceVariable: node name
]
