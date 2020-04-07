Class {
	#name : #RBRemovePoolVariableRefactoring,
	#superclass : #RBVariableRefactoring,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #preconditions }
RBRemovePoolVariableRefactoring >> checkClassReferencePoolVariable: anAssociation [
	class withAllSubclasses
		do: [ :sub | 
			sub realClass
				ifNotNil: [ :cls | 
					[ :behavior | 
					"Should look in the model, but currently that is not supported"
					(behavior whichSelectorsReferTo: anAssociation)
						ifNotEmpty: [ :sel | 
							self
								refactoringError:
									behavior name asString , '>>' , sel first , ' references '
										, anAssociation key ] ]
						value: cls;
						value: cls class ] ]
]

{ #category : #preconditions }
RBRemovePoolVariableRefactoring >> checkReferenceToPoolDictionary [
	| newPool |
	newPool := Smalltalk globals at: variableName asSymbol.
	newPool
		bindingsDo:
			[ :binding | self checkClassReferencePoolVariable: binding ]
]

{ #category : #preconditions }
RBRemovePoolVariableRefactoring >> preconditions [
	^ (RBCondition isMetaclass: class) not
		& (RBCondition includesPoolDictionary: variableName in: class)
		&
			(RBCondition
				withBlock: [ self checkReferenceToPoolDictionary.
					true ])
]

{ #category : #transforming }
RBRemovePoolVariableRefactoring >> transform [
	class removePoolDictionary: variableName asSymbol
]
