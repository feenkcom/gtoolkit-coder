Class {
	#name : #RBAddTraitUsageTransformation,
	#superclass : #RBTraitTransformation,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #private }
RBAddTraitUsageTransformation >> checkClassDoesNotIncludeTrait [
	class := class asClassWithTrait.
	class withAllSuperclasses
		do: [ :each | 
			(self includesTrait: traitName in: each)
				ifTrue: [ ^ self
						refactoringError: traitName , ' is already included in ' , each name ] ]
]

{ #category : #preconditions }
RBAddTraitUsageTransformation >> preconditions [
	^ super preconditions
		&
			(RBCondition
				withBlock: [ self checkClassDoesNotIncludeTrait.
					true ])
]

{ #category : #transforming }
RBAddTraitUsageTransformation >> transform [
	| newExpression |
	newExpression := class traitExpression
		ifNil: [ traitName ]
		ifNotNil: [ :exp | exp , ' + ' , traitName ].
	class traitExpression: newExpression.
	self model changes defineClass: class gtDefinitionString
]
