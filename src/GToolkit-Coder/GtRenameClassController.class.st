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
GtRenameClassController >> rename: oldNameString to: newNameString [
	| model |
	model := self createModel.
	^ RBRenameClassWithCommentsRefactoring
		model: model
		rename: (Smalltalk at: oldNameString asSymbol)
		to: newNameString
]
