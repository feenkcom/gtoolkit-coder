Class {
	#name : #GtSlotRenamedDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #converting }
GtSlotRenamedDifference >> asClassRefactorings: aClass [
	^ RBRenameInstanceVariableRefactoring
		rename: self oldName
		to: self newName
		in: aClass
]

{ #category : #converting }
GtSlotRenamedDifference >> asClassRefactoryChange: aClass in: aCompositeRefactoryChange [
	aCompositeRefactoryChange renameInstanceVariable: self oldName to: self newName in: aClass
]

{ #category : #accessing }
GtSlotRenamedDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtSlotRenamedDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtSlotRenamedDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtSlotRenamedDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtSlotRenamedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Renamed ';
		print: self oldName;
		nextPutAll: ' slot to ';
		print: self newName
]
