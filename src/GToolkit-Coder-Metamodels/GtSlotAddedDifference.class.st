Class {
	#name : #GtSlotAddedDifference,
	#superclass : #GtSlotDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtSlotAddedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBAddInstanceVariableRefactoring
		model: anRBModel
		variable: self slotName
		class: aClass
]

{ #category : #printing }
GtSlotAddedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Added ';
		print: self slotName;
		nextPutAll: ' slot'
]
