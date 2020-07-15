Extension { #name : #RBRenameInstanceVariableChange }

{ #category : #'*GToolkit-Coder' }
RBRenameInstanceVariableChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition targetDefinitionForBehavior: aClass.
	oldSource := aDefinition asDefinitionString.
	
	aDefinition slots renameSlotNamed: oldName asSymbol to: newName asSymbol.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: aClass
]
