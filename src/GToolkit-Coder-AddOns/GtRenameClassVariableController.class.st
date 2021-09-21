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
GtRenameClassVariableController >> rename: anOldName to: aNewName [
	| aModel aClass |

	aModel := self createModel.
	aClass := (aModel classFor: sourceCoderViewModel behavior) instanceSide
		whoDefinesClassVariable: anOldName.
	
	^ RBRenameClassVariableRefactoring
		  model: aModel
		  rename: anOldName
		  to: aNewName
		  in: aClass
]
