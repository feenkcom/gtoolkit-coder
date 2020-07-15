Extension { #name : #RBAddClassChange }

{ #category : #'*GToolkit-Coder' }
RBAddClassChange >> gtDiff [
	| aClass oldSource newSource |
	
	aClass := self changeClass.
	
	oldSource := (RBClass existingNamed: aClass name)
		model: RBNamespace new;
		gtRemoveSlotsFromTraits;
		gtDefinitionString.
	newSource := self definition.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: Class
]
