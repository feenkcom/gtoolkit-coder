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
	sourceCoder addClassVariable: self nodeName
]

{ #category : 'accessing' }
GtDefineClassVariableFixItAction >> id [
	<return: #BlElementId>

	^ GtDefineClassVariableFixItActionElementId
]
