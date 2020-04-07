Class {
	#name : #RBAddPoolVariableRefactoring,
	#superclass : #RBVariableRefactoring,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #preconditions }
RBAddPoolVariableRefactoring >> checkClassReferencePoolVariable: anAssociation existingPoolName: aString [
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
										, anAssociation key , ' which is defined in both '
										, variableName , ' and ' , aString ] ]
						value: cls;
						value: cls class ] ]
]

{ #category : #preconditions }
RBAddPoolVariableRefactoring >> checkConflictingPoolVariableNames [
	| newPool |
	newPool := Smalltalk globals at: variableName asSymbol.
	class sharedPools
		do: [ :pool | 
			newPool == pool
				ifFalse: [ pool
						bindingsDo: [ :binding | 
							(newPool includesKey: binding key)
								ifTrue: [ self
										checkClassReferencePoolVariable: binding
										existingPoolName: pool name ] ] ] ]
]

{ #category : #preconditions }
RBAddPoolVariableRefactoring >> preconditions [
	^ (RBCondition isMetaclass: class) not
		& (RBCondition isPoolDictionary: variableName in: self model)
		& (RBCondition includesPoolDictionary: variableName in: class) not
		&
			(RBCondition
				withBlock: [ self checkConflictingPoolVariableNames.
					true ])
]

{ #category : #transforming }
RBAddPoolVariableRefactoring >> transform [
	class addPoolDictionary: variableName asSymbol
]
