Class {
	#name : #GtRenameVariableController,
	#superclass : #GtRenameController,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #accessing }
GtRenameVariableController >> addRefactoringChangesPreview [
	super addRefactoringChangesPreview.
	coder requestStyleSourceTextAndAfterDo: [ self styleRenamedVariable ]
]

{ #category : #executing }
GtRenameVariableController >> installRenamer [
	self originalNode isNil
		ifTrue: [ ^ self ].
	newName := self originalNode name.
	renameInterval := self originalNode sourceInterval.
	self installRenameAction
]

{ #category : #accessing }
GtRenameVariableController >> originalName [
	^ node name
]

{ #category : #accessing }
GtRenameVariableController >> refactoring [
	self originalName = self newName
		ifTrue: [ ^ nil ].
	^ self rename: self originalName to: self newName
]

{ #category : #accessing }
GtRenameVariableController >> rename: oldName to: newName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRenameVariableController >> styleRenamedVariable [
	(coder sourceCode sourceText
		from: renameInterval first
		to: self renamePosition)
		attributes: {(BlTextForegroundAttribute paint: Color gray)}
]
