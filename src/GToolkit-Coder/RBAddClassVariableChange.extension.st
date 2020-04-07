Extension { #name : #RBAddClassVariableChange }

{ #category : #'*GToolkit-Coder' }
RBAddClassVariableChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition fromBehavior: aClass.
	oldSource := aDefinition asDefinitionString.
	
	aDefinition classVariables addClassVariableNamed: variable asSymbol.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: aClass
]
