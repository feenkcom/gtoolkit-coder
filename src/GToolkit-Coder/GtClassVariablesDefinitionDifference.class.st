Class {
	#name : #GtClassVariablesDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #printing }
GtClassVariablesDefinitionDifference >> printOn: aStream [
	aStream nextPutAll: 'Variables'
]
