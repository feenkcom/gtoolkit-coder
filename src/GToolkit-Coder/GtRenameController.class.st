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
		'newNode'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #executing }
GtRenameController >> acceptRename [
	self uninstallPreviewEventHandlers
]

{ #category : #private }
GtRenameController >> addRefactoringChangesPreview [
	newNode := nil.
	coder
		addRefactoringChangesPreview: self refactoring
		at: self positionForPreview
]

{ #category : #private }
GtRenameController >> calculateNewNode [
	self subclassResponsibility
]

{ #category : #executing }
GtRenameController >> cancelRename [
	self uninstallPreviewEventHandlers.
	sourceElement editor text: originalSource.
	coder removeRefactoringAttribute
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

{ #category : #private }
GtRenameController >> installPreviewEventHandlers [
	handlers := {(BlEventHandler
		on: BrTextEditorInsertedEvent
		do: [ :event | self addRefactoringChangesPreview ]).
	(BlEventHandler
		on: BrTextEditorDeletedEvent
		do: [ :event | self addRefactoringChangesPreview ]).
	(BlEventHandler
		on: BrTextEditorModifiedEvent
		do: [ :event | self addRefactoringChangesPreview ])}.
	handlers do: [ :each | coder sourceEditor addEventHandler: each ]
]

{ #category : #executing }
GtRenameController >> installRenamer [
	self subclassResponsibility
]

{ #category : #executing }
GtRenameController >> installRenamerOnInterval: interval [
	renameAction := GtRenameAction
		locations: {interval}
		element: sourceElement.
	renameAction
		when: GtRenameActionAnnoucement
		do: [ :ann | 
			ann eventType = #cancel
				ifTrue: [ self cancelRename ].
			ann eventType = #accept
				ifTrue: [ self acceptRename ] ].
	renameAction install
]

{ #category : #testing }
GtRenameController >> isRenaming [
	^ renameAction notNil and: [ renameAction isInstalled ]
]

{ #category : #private }
GtRenameController >> newNode [
	newNode isNil
		ifTrue: [ self calculateNewNode ].
	^ newNode
]

{ #category : #accessing }
GtRenameController >> originalNode [
	^ node ifNil: [ node := coder rbNodeAtCursor: sourceElement ]
]

{ #category : #private }
GtRenameController >> positionForPreview [
	^ self newNode ifNotNil: [ :ast | ast stop ]
]

{ #category : #accessing }
GtRenameController >> refactoring [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtRenameController >> refactoringName [
	^ self subclassResponsibility
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
GtRenameController >> uninstallPreviewEventHandlers [
	handlers isNil
		ifTrue: [ ^ self ].
	handlers do: [ :each | coder sourceEditor removeEventHandler: each ]
]
