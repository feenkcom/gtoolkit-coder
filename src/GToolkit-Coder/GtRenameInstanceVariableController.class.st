Class {
	#name : #GtRenameInstanceVariableController,
	#superclass : #GtRenameVariableController,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #accessing }
GtRenameInstanceVariableController >> refactoringName [
	^ 'Rename instance variable'
]

{ #category : #accessing }
GtRenameInstanceVariableController >> rename: oldName to: newName [
	| model class |
	model := self createModel.
	class := (model classFor: coder classOrMetaClass)
		whoDefinesInstanceVariable: oldName.
	^ RBRenameInstanceVariableRefactoring
		model: model
		rename: oldName
		to: newName
		in: class
]
