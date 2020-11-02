Class {
	#name : #GtTraitAddedToDefinitionDifference,
	#superclass : #GtTraitDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtTraitAddedToDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBAddTraitUsageRefactoring new
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
