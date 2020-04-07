Class {
	#name : #GtClassSuperclassDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #converting }
GtClassSuperclassDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRenameClassVariableRefactoring
		model: anRBModel
		rename: self oldName
		to: self newName
		in: aClass
]

{ #category : #accessing }
GtClassSuperclassDefinitionDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtClassSuperclassDefinitionDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtClassSuperclassDefinitionDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtClassSuperclassDefinitionDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtClassSuperclassDefinitionDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Superclass changed from ';
		print: self oldName;
		nextPutAll: ' to ';
		print: self newName
]
