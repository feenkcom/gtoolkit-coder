Class {
	#name : #GtClassVariableRemovedDifference,
	#superclass : #GtClassVariableDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtClassVariableRemovedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRemoveClassVariableRefactoring
		model: anRBModel
		variable: self classVariableName
		class: aClass
]

{ #category : #printing }
GtClassVariableRemovedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Removed ';
		print: self classVariableName;
		nextPutAll: ' class variable'
]
