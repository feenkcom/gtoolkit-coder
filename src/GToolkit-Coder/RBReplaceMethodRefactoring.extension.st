Extension { #name : 'RBReplaceMethodRefactoring' }

{ #category : '*GToolkit-Coder' }
RBReplaceMethodRefactoring >> gtPreconditions [
	|conditions|
	conditions := (RBCondition withBlock: [ self haveSameNumberOfArgs. true])
						&(RBCondition definesSelector: oldSelector in: class )
						& (RBCondition definesSelector: newSelector in: class ).
	^ conditions
]
