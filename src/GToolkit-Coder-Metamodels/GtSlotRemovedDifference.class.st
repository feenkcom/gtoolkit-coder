Class {
	#name : #GtSlotRemovedDifference,
	#superclass : #GtSlotDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtSlotRemovedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRemoveInstanceVariableRefactoring
		model: anRBModel
		variable: self slotName
		class: aClass
]

{ #category : #printing }
GtSlotRemovedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Removed ';
		print: self slotName;
		nextPutAll: ' slot'
]
