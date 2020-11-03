Class {
	#name : #GtSlotsDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #printing }
GtSlotsDefinitionDifference >> printOn: aStream [
	aStream nextPutAll: 'Slots'
]
