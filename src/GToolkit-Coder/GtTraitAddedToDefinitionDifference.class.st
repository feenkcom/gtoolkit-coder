Class {
	#name : #GtTraitAddedToDefinitionDifference,
	#superclass : #GtTraitDifference,
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #converting }
GtTraitAddedToDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBAddTraitUsageTransformation new
		model: anRBModel;
		class: aClass traitName: self traitName
]

{ #category : #printing }
GtTraitAddedToDefinitionDifference >> printOn: aStream [
	aStream
		nextPutAll: 'Added ';
		print: self traitName;
		nextPutAll: ' trait'
]
