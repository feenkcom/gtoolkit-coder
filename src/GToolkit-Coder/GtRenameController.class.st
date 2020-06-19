Class {
	#name : #GtRenameController,
	#superclass : #Object,
	#instVars : [
		'coder',
		'sourceElement',
		'originalSource',
		'handlers',
		'renameAction',
		'node',
		'newName',
		'renameInterval'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #executing }
GtRenameController >> acceptRename [
	renameAction notNil
		ifTrue: [ renameAction accept ]
]

{ #category : #private }
GtRenameController >> addRefactoringChangesPreview [
	coder
		addRefactoringChangesPreview: self refactoring
		at: self renamePosition
]

{ #category : #executing }
GtRenameController >> cancelRename [
	renameAction notNil
		ifTrue: [ renameAction cancel ].
	self restoreText
]

{ #category : #accessing }
GtRenameController >> coder [
	^ coder
]

{ #category : #accessing }
GtRenameController >> coder: methodCoder [
	coder := methodCoder
]

{ #category : #executing }
GtRenameController >> createModel [
	| model |
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	model name: self refactoringName.
	((model classFor: coder classOrMetaClass)
		sourceCodeFor: coder selector) ~= originalSource asString
		ifTrue: [ (model classFor: coder classOrMetaClass)
				compile: originalSource asString
				classified: coder category ].
	^ model
]

{ #category : #executing }
GtRenameController >> execute [
	[ self saveSource.
	self installRenamer ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #executing }
GtRenameController >> installRenameAction [
	renameAction := GtRenameAction
		locations: {renameInterval}
		element: sourceElement.
	renameAction
		when: GtRenameActionAnnouncement
		do: [ :ann | 
			(#(#textUpdated accept) includes: ann eventType)
				ifTrue: [ self updateName: renameAction newName ].
			ann eventType = #cancel
				ifTrue: [ coder removeRefactoringAttribute ] ].
	renameAction install
]

{ #category : #executing }
GtRenameController >> installRenamer [
	self subclassResponsibility
]

{ #category : #testing }
GtRenameController >> isRenaming [
	^ renameAction notNil and: [ renameAction isInstalled ]
]

{ #category : #accessing }
GtRenameController >> newName [
	^ newName
]

{ #category : #accessing }
GtRenameController >> originalName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRenameController >> originalNode [
	^ node ifNil: [ node := coder rbNodeAtCursor: sourceElement ]
]

{ #category : #accessing }
GtRenameController >> refactoring [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRenameController >> refactoringName [
	^ self subclassResponsibility
]

{ #category : #private }
GtRenameController >> removeRefactoringAttribute [
	| editor |
	editor := renameAction editor.
	editor text
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ]
]

{ #category : #private }
GtRenameController >> renamePosition [
	^ (renameAction isNil or: [ renameAction isInstalled ])
		ifTrue: [ renameInterval last ]
		ifFalse: [ renameInterval last + self newName size - self originalName size ]
]

{ #category : #private }
GtRenameController >> restoreText [
	sourceElement editor text: originalSource
]

{ #category : #executing }
GtRenameController >> saveSource [
	originalSource := coder sourceEditor text copy
]

{ #category : #accessing }
GtRenameController >> sourceElement [
	^ sourceElement
]

{ #category : #accessing }
GtRenameController >> sourceElement: textElement [
	sourceElement := textElement
]

{ #category : #private }
GtRenameController >> updateName: aString [
	newName := aString.
	self addRefactoringChangesPreview
]
