Class {
	#name : #GtTraitRemovedFromDefinitionDifference,
	#superclass : #GtTraitDifference,
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #converting }
GtTraitRemovedFromDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBRemoveTraitUsageTransformation new
		model: anRBModel;
		class: aClass traitName: self traitName
]

{ #category : #printing }
GtTraitRemovedFromDefinitionDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Removed ';
		print: self traitName;
		nextPutAll: ' trait'
]
