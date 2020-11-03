Class {
	#name : #GtClassVariableAddedDifference,
	#superclass : #GtClassVariableDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtClassVariableAddedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBAddClassVariableRefactoring
		model: anRBModel
		variable: self classVariableName
		class: aClass
]

{ #category : #printing }
GtClassVariableAddedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Added ';
		print: self classVariableName;
		nextPutAll: ' class variable'
]
