Extension { #name : #RBAddPoolVariableChange }

{ #category : #'*GToolkit-Coder' }
RBAddPoolVariableChange >> changeObject [
	^ Smalltalk globals at: self variable asSymbol
]

{ #category : #'*GToolkit-Coder' }
RBAddPoolVariableChange >> gtDiff [
	| aClass aDefinition oldSource newSource |
	
	aClass := self changeClass.
	aDefinition := GtBehaviorDefinition fromBehavior: aClass.
	oldSource := aDefinition asDefinitionString.
	
	aDefinition pools addPoolNamed: variable asSymbol.
	newSource := aDefinition asDefinitionString.

	^ ClassDiffBuilder
		from: oldSource
		to: newSource
		inClass: aClass
]
