Class {
	#name : 'GtRenameVariableController',
	#superclass : 'GtRenameController',
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'accessing' }
GtRenameVariableController >> addRefactoringChangesPreview [
	super addRefactoringChangesPreview.
	self styleRenamedVariable
]

{ #category : 'executing' }
GtRenameVariableController >> installRenamer [
	newName := self originalNode source.
	renameInterval := self originalNode sourceInterval.

	self installRenameAction
]

{ #category : 'accessing' }
GtRenameVariableController >> originalName [
	^ self originalNode source
]

{ #category : 'accessing' }
GtRenameVariableController >> refactoring [
	self originalName = self newName
		ifTrue: [ ^ nil ].
	^ self rename: self originalName to: self newName
]

{ #category : 'accessing' }
GtRenameVariableController >> rename: oldName to: newName [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
GtRenameVariableController >> styleRenamedVariable [
	(self sourceText
		from: renameInterval first
		to: self renamePosition)
			attributes: {(BlTextForegroundAttribute paint: Color gray) }
]
