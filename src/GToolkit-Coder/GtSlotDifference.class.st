Class {
	#name : #GtSlotDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #accessing }
GtSlotDifference >> slotName [
	^ slotName
]

{ #category : #accessing }
GtSlotDifference >> slotName: anObject [
	slotName := anObject
]
