Class {
	#name : #RBTraitTransformation,
	#superclass : #RBRefactoring,
	#instVars : [
		'class',
		'traitName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBTraitTransformation class >> traitName: aString class: aClass [
	^ self new
		class: aClass traitName: aString;
		yourself
]

{ #category : #'initialize-release' }
RBTraitTransformation >> class: aClass traitName: aString [
	class := self model classFor: aClass.
	class gtInstanceVariableNames.
	traitName := aString
]

{ #category : #private }
RBTraitTransformation >> includesTrait: aString in: aRBClass [
	| expression |
	aRBClass traitExpression isNil
		ifTrue: [ ^ false ].
	expression := RBParser parseExpression: aRBClass traitExpression.
	expression
		nodesDo: [ :node | 
			(node isVariable and: [ node name = aString ])
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #preconditions }
RBTraitTransformation >> preconditions [
	^ (RBCondition isMetaclass: class) not
		&
			(RBCondition
				withBlock: [ | trait |
					trait := Smalltalk globals
						at: traitName asSymbol
						ifAbsent: [ ^ self refactoringError: traitName , ' does not exist' ].
					trait isTrait
						ifFalse: [ ^ self refactoringError: traitName , ' is not a trait' ].
					true ])
]
