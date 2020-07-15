Class {
	#name : #RBRemoveTraitUsageTransformation,
	#superclass : #RBTraitTransformation,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #preconditions }
RBRemoveTraitUsageTransformation >> checkClassIncludesTrait [
	class := class asClassWithTrait.
	(self includesTrait: traitName in: class)
		ifFalse:
			[ ^ self refactoringError: traitName , ' is not used in ' , class name ]
]

{ #category : #'gt-extension' }
RBRemoveTraitUsageTransformation >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' trait usage ' asRopedText;
		append: traitName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class name asRopedText
]

{ #category : #preconditions }
RBRemoveTraitUsageTransformation >> preconditions [
	^ super preconditions
		&
			(RBCondition
				withBlock: [ self checkClassIncludesTrait.
					true ])
]

{ #category : #transforming }
RBRemoveTraitUsageTransformation >> removeTraitFromExpression: anAST [
	anAST isVariable
		ifTrue: [ ^ anAST name = traitName
				ifTrue: [ nil ]
				ifFalse: [ anAST ] ].
	(anAST isMessage and: [ anAST isBinary ])
		ifTrue: [ | left right |
			left := self removeTraitFromExpression: anAST receiver.
			right := self removeTraitFromExpression: anAST arguments first.
			right isNil
				ifTrue: [ ^ left ].
			left isNil
				ifTrue: [ ^ anAST selector = #-
						ifTrue: [ nil ]
						ifFalse: [ right ] ].
			^ RBMessageNode
				receiver: left
				selector: anAST selector
				arguments: {right} ].
	anAST isLiteral
		ifTrue: [ ^ anAST ].
	self refactoringError: 'Unknown trait expression'
]

{ #category : #transforming }
RBRemoveTraitUsageTransformation >> traitExpressionAfterRemoval [
	| expression ast |
	expression := class traitExpression.
	ast := RBParser parseExpression: expression.
	ast := self removeTraitFromExpression: ast.
	^ ast isNil
		ifTrue: [ '{}' ]
		ifFalse: [ ast formattedCode ]
]

{ #category : #transforming }
RBRemoveTraitUsageTransformation >> transform [
	class traitExpression: self traitExpressionAfterRemoval.
	self model changes defineClass: class gtDefinitionString
]
