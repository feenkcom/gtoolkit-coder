Class {
	#name : #GtDefineClassVariableFixItAction,
	#superclass : #GtFixItAction,
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtDefineClassVariableFixItAction >> description [
	^ 'Add class variable ' , node name , ' to class '
		, sourceCoder classOrMetaClass name
]

{ #category : #accessing }
GtDefineClassVariableFixItAction >> executeOn: anEditorElement [
	sourceCoder addClassVariable: node name
]
