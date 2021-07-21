Class {
	#name : #GtRenameClassController,
	#superclass : #GtRenameVariableController,
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #accessing }
GtRenameClassController >> refactoringName [
	^ 'Rename class'
]

{ #category : #accessing }
GtRenameClassController >> rename: oldNameString to: newNameString [
	| model |
	model := self createModel.
	^ GtRBRenameClassWithCommentsRefactoring
		model: model
		rename: (Smalltalk at: oldNameString asSymbol)
		to: newNameString
]
