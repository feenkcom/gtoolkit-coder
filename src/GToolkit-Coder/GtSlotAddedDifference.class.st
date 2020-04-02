Class {
	#name : #GtSlotAddedDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #converting }
GtSlotAddedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBAddInstanceVariableRefactoring
		model: anRBModel
		variable: self slotName
		class: aClass
]

{ #category : #converting }
GtSlotAddedDifference >> asClassRefactoryChange: aClass in: aCompositeRefactoryChange [
	aCompositeRefactoryChange addInstanceVariable: self slotName to: aClass
]

{ #category : #printing }
GtSlotAddedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Added ';
		print: self slotName;
		nextPutAll: ' slot'
]

{ #category : #accessing }
GtSlotAddedDifference >> slotName [
	^ slotName
]

{ #category : #accessing }
GtSlotAddedDifference >> slotName: anObject [
	slotName := anObject
]
