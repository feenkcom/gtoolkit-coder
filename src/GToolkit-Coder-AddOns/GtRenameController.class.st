Class {
	#name : 'GtRenameController',
	#superclass : 'GtSourceCoderRefactoringController',
	#instVars : [
		'handlers',
		'renameAction',
		'node',
		'newName',
		'renameInterval',
		'completionAction'
	],
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'private' }
GtRenameController >> addRefactoringChangesPreview [
	| aRefactoring aRenamePosition |
	self removeRefactoringAttribute.

	aRefactoring := self refactoring.
	aRefactoring
		ifNil: [ ^ self cancelRefactoring ].

	aRenamePosition := self renamePosition.

	self
		addRefactoringChangesPreview: aRefactoring
		at: aRenamePosition
		whenComplete: [
			self removeRefactoringAttribute.
			self completionAction value.
			self allowSave ]
]

{ #category : 'executing' }
GtRenameController >> cancelRefactoring [
	self removeRefactoringAttribute.
	self restoreText.
	self allowSave
]

{ #category : 'accessing' }
GtRenameController >> completionAction [
	^ completionAction ifNil: [ [  ] ]
]

{ #category : 'accessing' }
GtRenameController >> completionAction: aBlock [
	completionAction := aBlock
]

{ #category : 'executing' }
GtRenameController >> createModel [
	| model |
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	model name: self refactoringName.
	sourceCoderViewModel coderModel isForMethod
		ifTrue: [ ((model classFor: sourceCoderViewModel behavior) sourceCodeFor: sourceCoderViewModel selector)
				~= originalSource asString
				ifTrue: [ (model classFor: sourceCoderViewModel behavior)
						compile: originalSource asString
						classified: sourceCoderViewModel protocol ] ].
	^ model
]

{ #category : 'accessing' }
GtRenameController >> cursorPositionDo: aBlock [
	sourceCoderViewModel cursors
		do: [ :eachCursor | ^ aBlock value: (eachCursor position + 1 min: self sourceText size) ]
]

{ #category : 'executing' }
GtRenameController >> installRenameAction [
	renameAction := GtRenameAction2
		locations: { renameInterval }
		textualCoderViewModel: sourceCoderViewModel.
	
	renameAction selectAll: true.	
	
	self preventSave.

	renameAction
		when: GtRenameActionAnnouncement
		do: [ :ann | 
			(#(#textUpdated #accept) includes: ann eventType)
				ifTrue: [ self updateName: renameAction newName ].
			(#(#tab #shiftTab) includes: ann eventType)
				ifTrue: [ self tab: ann eventType = #tab ].
			ann eventType = #cancel
				ifTrue: [ self cancelRefactoring ] ].

	self installValidation.
	renameAction install
]

{ #category : 'executing' }
GtRenameController >> installRenamer [
	self subclassResponsibility
]

{ #category : 'accessing' }
GtRenameController >> installValidation [
	renameAction forVariableOrUnaryMessage
]

{ #category : 'accessing' }
GtRenameController >> newName [
	^ newName
]

{ #category : 'accessing' }
GtRenameController >> originalName [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
GtRenameController >> originalNode [
	<return: #GtPharoProgramNode>

	^ node
]

{ #category : 'accessing' }
GtRenameController >> originalNode: aGtPharoProgramNode [
	node := aGtPharoProgramNode
]

{ #category : 'private' }
GtRenameController >> renamePosition [
	^ (renameAction isNil or: [ renameAction isInstalled ])
		ifTrue: [ renameInterval last ]
		ifFalse: [ renameInterval last + self newName size - self originalName size ]
]

{ #category : 'executing' }
GtRenameController >> safelyExecute [
	self installRenamer
]

{ #category : 'private' }
GtRenameController >> tab: forward [
]

{ #category : 'private' }
GtRenameController >> updateName: aString [
	newName := aString.
	self addRefactoringChangesPreview
]
