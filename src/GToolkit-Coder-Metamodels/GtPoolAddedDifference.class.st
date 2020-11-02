Class {
	#name : #GtPoolAddedDifference,
	#superclass : #GtPoolDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtPoolAddedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBAddPoolVariableRefactoring
		model: anRBModel
		variable: self poolName
		class: aClass
]

{ #category : #printing }
GtPoolAddedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Added ';
		print: self poolName;
		nextPutAll: ' pool'
]
