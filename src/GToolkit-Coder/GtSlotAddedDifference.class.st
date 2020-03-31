Class {
	#name : #GtSlotAddedDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

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
