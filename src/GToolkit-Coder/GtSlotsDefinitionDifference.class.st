Class {
	#name : #GtSlotsDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #printing }
GtSlotsDefinitionDifference >> printOn: aStream [
	aStream nextPutAll: 'Slots'
]
