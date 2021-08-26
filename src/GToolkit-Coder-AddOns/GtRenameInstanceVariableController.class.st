Class {
	#name : 'GtRenameInstanceVariableController',
	#superclass : 'GtRenameVariableController',
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'accessing' }
GtRenameInstanceVariableController >> refactoringName [
	^ 'Rename instance variable'
]

{ #category : 'accessing' }
GtRenameInstanceVariableController >> rename: oldName to: newName [
	| model class |
	model := self createModel.
	class := (model classFor: coder behavior)
		whoDefinesInstanceVariable: oldName.
	^ RBRenameInstanceVariableRefactoring
		model: model
		rename: oldName
		to: newName
		in: class
]
