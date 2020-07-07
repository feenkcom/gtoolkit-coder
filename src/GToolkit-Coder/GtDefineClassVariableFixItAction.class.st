Class {
	#name : #GtDefineClassVariableFixItAction,
	#superclass : #GtFixItAction,
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #accessing }
GtDefineClassVariableFixItAction >> description [
	^ 'Add class variable ' , node name , ' to class '
		, methodCoder classOrMetaClass name
]

{ #category : #accessing }
GtDefineClassVariableFixItAction >> execute [
	methodCoder addClassVariable: node name
]
