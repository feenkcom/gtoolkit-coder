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
GtDefineInstanceVariableFixItAction >> executeOn: anEditorElement [
	sourceCoder addInstanceVariable: node name
]

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> id [
	<return: #BlElementId>

	^ GtDefineInstanceVariableFixItActionElementId
]
