Extension { #name : #RBRenameClassChange }

{ #category : #'*GToolkit-Coder' }
RBRenameClassChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition targetDefinitionForBehavior: aClass.
	
	oldSource := aDefinition asDefinitionString.
	
	aDefinition name: newName.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: Class
]
