Class {
	#name : #GtClassVariablesDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #printing }
GtClassVariablesDefinitionDifference >> printOn: aStream [
	aStream nextPutAll: 'Variables'
]
