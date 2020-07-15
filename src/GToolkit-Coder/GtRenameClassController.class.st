Class {
	#name : #GtRenameClassController,
	#superclass : #GtRenameVariableController,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #accessing }
GtRenameClassController >> refactoringName [
	^ 'Rename class'
]

{ #category : #accessing }
GtRenameClassController >> rename: oldName to: newName [
	| model |
	model := self createModel.
	^ RBRenameClassRefactoring
		model: model
		rename: (Smalltalk at: oldName asSymbol)
		to: newName
]
