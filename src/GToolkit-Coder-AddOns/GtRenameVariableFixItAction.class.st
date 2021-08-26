Class {
	#name : 'GtRenameVariableFixItAction',
	#superclass : 'GtFixItVariableNodeAction',
	#instVars : [
		'newName'
	],
	#category : 'GToolkit-Coder-AddOns-FixIt'
}

{ #category : 'accessing' }
GtRenameVariableFixItAction >> description [
	^ 'Use ' , newName , ' instead of ' , self nodeName
]

{ #category : 'accessing' }
GtRenameVariableFixItAction >> executeOn: anEditorElement [
	| newSource |
	newSource := sourceCoder currentSourceString.
	newSource := (newSource first: self startPosition - 1) , newName
		, (newSource allButFirst: self stopPosition).
	sourceCoder currentSourceString: newSource
]

{ #category : 'accessing' }
GtRenameVariableFixItAction >> id [
	<return: #BlElementId>

	^ GtRenameVariableFixItActionElementId
]

{ #category : 'initialization' }
GtRenameVariableFixItAction >> newName: aString [
	newName := aString
]
