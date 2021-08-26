Class {
	#name : 'GtDefineClassVariableFixItAction',
	#superclass : 'GtFixItVariableNodeAction',
	#category : 'GToolkit-Coder-AddOns-FixIt'
}

{ #category : 'accessing' }
GtDefineClassVariableFixItAction >> description [
	^ 'Add class variable ' , self nodeName , ' to class ', sourceCoder behavior name
]

{ #category : 'accessing' }
GtDefineClassVariableFixItAction >> executeOn: anEditorElement [
	sourceCoder addClassVariable: node name
]

{ #category : 'accessing' }
GtDefineClassVariableFixItAction >> id [
	<return: #BlElementId>

	^ GtDefineClassVariableFixItActionElementId
]
