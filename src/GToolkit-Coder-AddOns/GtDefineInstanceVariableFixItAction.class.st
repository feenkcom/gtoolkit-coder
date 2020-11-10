Class {
	#name : #GtDefineInstanceVariableFixItAction,
	#superclass : #GtFixItAction,
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> description [
	^ 'Add instance variable ' , node name , ' to class '
		, sourceCoder behavior name
]

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> execute [
	sourceCoder addInstanceVariable: node name
]
