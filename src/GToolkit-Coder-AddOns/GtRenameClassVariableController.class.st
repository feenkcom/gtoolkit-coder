Class {
	#name : 'GtRenameClassVariableController',
	#superclass : 'GtRenameVariableController',
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'accessing' }
GtRenameClassVariableController >> refactoringName [
	^ 'Rename class variable'
]

{ #category : 'accessing' }
GtRenameClassVariableController >> rename: oldName to: newName [

	| model class |
	model := self createModel.
	class := (model classFor: coder behavior) instanceSide 
		         whoDefinesClassVariable: oldName.
	^ RBRenameClassVariableRefactoring
		  model: model
		  rename: oldName
		  to: newName
		  in: class
]
