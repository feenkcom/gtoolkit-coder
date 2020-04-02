Class {
	#name : #GtSlotRemovedDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #converting }
GtSlotRemovedDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRemoveInstanceVariableRefactoring
		model: anRBModel
		variable: self slotName
		class: aClass
]

{ #category : #converting }
GtSlotRemovedDifference >> asClassRefactoryChange: aClass in: aCompositeRefactoryChange [
	aCompositeRefactoryChange removeInstanceVariable: self slotName from: aClass
]

{ #category : #printing }
GtSlotRemovedDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Removed ';
		print: self slotName;
		nextPutAll: ' slot'
]

{ #category : #accessing }
GtSlotRemovedDifference >> slotName [
	^ slotName
]

{ #category : #accessing }
GtSlotRemovedDifference >> slotName: anObject [
	slotName := anObject
]
