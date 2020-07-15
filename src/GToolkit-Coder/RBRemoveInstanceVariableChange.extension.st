Extension { #name : #RBRemoveInstanceVariableChange }

{ #category : #'*GToolkit-Coder' }
RBRemoveInstanceVariableChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition targetDefinitionForBehavior: aClass.
	oldSource := aDefinition asDefinitionString.
	
	aDefinition slots removeSlotNamed: variable asSymbol.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: aClass
]
