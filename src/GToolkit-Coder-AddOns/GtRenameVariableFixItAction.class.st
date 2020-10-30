Class {
	#name : #GtRenameVariableFixItAction,
	#superclass : #GtFixItAction,
	#instVars : [
		'newName'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtRenameVariableFixItAction >> description [
	^ 'Use ' , newName , ' instead of ' , node name
]

{ #category : #accessing }
GtRenameVariableFixItAction >> execute [
	| newSource |
	newSource := sourceCoder currentSourceString.
	newSource := (newSource first: node start - 1) , newName
		, (newSource allButFirst: node stop).
	sourceCoder currentSourceString: newSource
]

{ #category : #initialization }
GtRenameVariableFixItAction >> newName: aString [
	newName := aString
]
