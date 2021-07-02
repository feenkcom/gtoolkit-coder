Class {
	#name : #GtDefineInstanceVariableFixItAction,
	#superclass : #GtFixItVariableNodeAction,
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtDefineInstanceVariableFixItAction >> description [
	^ 'Add slot ' , self nodeName , ' in ', sourceCoder behavior name
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
