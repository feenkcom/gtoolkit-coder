Class {
	#name : #GtClassVariableRenamedDifference,
	#superclass : #GtClassVariableDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #converting }
GtClassVariableRenamedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRenameClassVariableRefactoring
		model: anRBModel
		rename: self oldName
		to: self newName
		in: aClass
]

{ #category : #accessing }
GtClassVariableRenamedDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtClassVariableRenamedDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtClassVariableRenamedDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtClassVariableRenamedDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtClassVariableRenamedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Renamed ';
		print: self oldName;
		nextPutAll: ' class variable to ';
		print: self newName
]
