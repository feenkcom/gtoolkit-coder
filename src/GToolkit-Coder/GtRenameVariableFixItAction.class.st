Class {
	#name : #GtRenameVariableFixItAction,
	#superclass : #GtFixItAction,
	#instVars : [
		'newName'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #accessing }
GtRenameVariableFixItAction >> description [
	^ 'Use ' , newName , ' instead of ' , node name
]

{ #category : #accessing }
GtRenameVariableFixItAction >> execute [
	| newSource |
	newSource := methodCoder source.
	newSource := (newSource first: node start - 1) , newName
		, (newSource allButFirst: node stop).
	methodCoder replaceSourceTextWith: newSource
]

{ #category : #initialization }
GtRenameVariableFixItAction >> newName: aString [
	newName := aString
]
