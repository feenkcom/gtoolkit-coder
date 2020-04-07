Class {
	#name : #GtTraitAddedToDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'traitName'
	],
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #printing }
GtTraitAddedToDefinitionDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Added ';
		print: self traitName;
		nextPutAll: ' trait'
]

{ #category : #accessing }
GtTraitAddedToDefinitionDifference >> traitName [
	^ traitName
]

{ #category : #accessing }
GtTraitAddedToDefinitionDifference >> traitName: anObject [
	traitName := anObject
]
