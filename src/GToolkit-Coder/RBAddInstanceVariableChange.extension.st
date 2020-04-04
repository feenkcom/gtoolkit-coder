Extension { #name : #RBAddInstanceVariableChange }

{ #category : #'*GToolkit-Coder' }
RBAddInstanceVariableChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition fromBehavior: aClass.
	oldSource := aDefinition asDefinitionString.
	
	aDefinition slots addSlotNamed: variable asSymbol.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: aClass
]
