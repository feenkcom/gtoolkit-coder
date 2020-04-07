Class {
	#name : #GtSlotDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #accessing }
GtSlotDifference >> slotName [
	^ slotName
]

{ #category : #accessing }
GtSlotDifference >> slotName: anObject [
	slotName := anObject
]
