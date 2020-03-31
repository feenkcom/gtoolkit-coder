Class {
	#name : #GtSlotRemovedDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

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
