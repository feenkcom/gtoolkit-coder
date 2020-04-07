Class {
	#name : #GtPoolRemovedDifference,
	#superclass : #GtPoolDifference,
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #converting }
GtPoolRemovedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRemovePoolVariableRefactoring
		model: anRBModel
		variable: self poolName
		class: aClass
]

{ #category : #printing }
GtPoolRemovedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Removed ';
		print: self poolName;
		nextPutAll: ' pool'
]
