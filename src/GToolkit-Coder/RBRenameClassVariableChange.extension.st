Extension { #name : #RBRenameClassVariableChange }

{ #category : #'*GToolkit-Coder' }
RBRenameClassVariableChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition fromBehavior: aClass.
	oldSource := aDefinition asDefinitionString.
	
	aDefinition classVariables renameClassVariableNamed: oldName asSymbol to: newName asSymbol.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: aClass
]
