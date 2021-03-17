Class {
	#name : #GtDefineInstanceVariableFixItAction,
	#superclass : #GtFixItVariableNodeAction,
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> description [
	^ 'Add instance variable ' , self nodeName , ' to class ', sourceCoder behavior name
]

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> executeOn: anEditorElement [
	sourceCoder addInstanceVariable: self nodeName
]

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> id [
	<return: #BlElementId>

	^ GtDefineInstanceVariableFixItActionElementId
]
