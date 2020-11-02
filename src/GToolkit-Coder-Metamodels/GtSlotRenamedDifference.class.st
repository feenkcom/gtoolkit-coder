Class {
	#name : #GtSlotRenamedDifference,
	#superclass : #GtSlotDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtSlotRenamedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRenameInstanceVariableRefactoring
		model: anRBModel
		rename: self oldName
		to: self newName
		in: aClass
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
