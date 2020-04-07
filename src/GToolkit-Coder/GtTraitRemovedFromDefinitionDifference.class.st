Class {
	#name : #GtTraitRemovedFromDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'traitName'
	],
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #printing }
GtTraitRemovedFromDefinitionDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Removed ';
		print: self traitName;
		nextPutAll: ' trait'
]

{ #category : #accessing }
GtTraitRemovedFromDefinitionDifference >> traitName [
	^ traitName
]

{ #category : #accessing }
GtTraitRemovedFromDefinitionDifference >> traitName: anObject [
	traitName := anObject
]
