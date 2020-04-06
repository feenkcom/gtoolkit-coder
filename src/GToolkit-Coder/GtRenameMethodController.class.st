Class {
	#name : #GtRenameMethodController,
	#superclass : #Object,
	#instVars : [
		'coder',
		'sourceElement',
		'selector',
		'someImplementor',
		'node',
		'newNode',
		'renameAction',
		'originalSource',
		'handlers'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #executing }
GtRenameMethodController >> acceptRename [
	self uninstallPreviewEventHandlers
]

{ #category : #private }
GtRenameMethodController >> addRefactoringChangesPreview [
	newNode := nil.
	self removeRefactoringAttribute.
	self refactoring
		ifNotNil: [ :ref | 
			| position |
			position := self newNode keywordsIntervals last last.
			(coder sourceEditor text from: position to: position)
				attributes: {(GtRefactoringChangesAttribute new refactoring: ref)}.
			coder sourceEditor updater all update ]
]

{ #category : #executing }
GtRenameMethodController >> cancelRename [
	self uninstallPreviewEventHandlers.
	sourceElement editor text: originalSource.
	self removeRefactoringAttribute
]

{ #category : #accessing }
GtRenameMethodController >> coder [
	^ coder
]

{ #category : #accessing }
GtRenameMethodController >> coder: methodCoder [
	coder := methodCoder
]

{ #category : #executing }
GtRenameMethodController >> createModel [
	| model |
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	model name: 'Rename method'.
	((model classFor: coder classOrMetaClass)
		sourceCodeFor: coder selector) ~= originalSource asString
		ifTrue: [ (model classFor: coder classOrMetaClass)
				compile: originalSource asString
				classified: coder category ].
	^ model
]

{ #category : #executing }
GtRenameMethodController >> execute [
	[ self saveSource.
	self installRenamer ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #private }
GtRenameMethodController >> installPreviewEventHandlers [
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
GtRenameMethodController >> installRenamer [
	coder
		cursorPositionDo: [ :position | 
			node := coder rbNodeAtCursor: sourceElement.
			selector := node selector.
			self someImplementor isNil
				ifTrue: [ ^ self ].
			node keywordsIntervals
				do: [ :interval | 
					(interval includes: position)
						ifTrue: [ self installRenamerOnInterval: interval.
							self installPreviewEventHandlers ] ] ]
]

{ #category : #executing }
GtRenameMethodController >> installRenamerOnInterval: interval [
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
GtRenameMethodController >> isRenaming [
	^ renameAction notNil and: [ renameAction isInstalled ]
]

{ #category : #private }
GtRenameMethodController >> newNode [
	| newAST |
	newNode isNil
		ifTrue: [ newAST := coder rbAST.
			newAST notNil
				ifTrue: [ node isMethod
						ifTrue: [ newNode := newAST ]
						ifFalse: [ newAST
								nodesDo: [ :each | 
									(each isMessage
										and: [ each start = node start
												and: [ each arguments = node arguments
														and: [ each receiver = node receiver ] ] ])
										ifTrue: [ newNode := each ] ] ] ] ].
	^ newNode
]

{ #category : #private }
GtRenameMethodController >> newSelectorName [
	^ self newNode ifNotNil: [ :n | n selector ]
]

{ #category : #private }
GtRenameMethodController >> refactoring [
	| implementor newSelector model |
	implementor := self someImplementor.
	implementor isNil
		ifTrue: [ ^ nil ].
	newSelector := self newSelectorName.
	newSelector = selector
		ifTrue: [ ^ nil ].
	model := self createModel.
	^ RBRenameMethodRefactoring
		model: model
		renameMethod: selector
		in: (model classFor: implementor)
		to: newSelector
		permutation: (1 to: selector numArgs)
]

{ #category : #private }
GtRenameMethodController >> removeRefactoringAttribute [
	coder sourceEditor text
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ].
	coder sourceEditor updater all update
]

{ #category : #executing }
GtRenameMethodController >> saveSource [
	originalSource := coder sourceEditor text copy
]

{ #category : #private }
GtRenameMethodController >> someImplementor [
	^ someImplementor
		ifNil: [ (SystemNavigation default allImplementorsOf: selector)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :impls | someImplementor := impls anyOne methodClass ] ]
]

{ #category : #accessing }
GtRenameMethodController >> sourceElement [
	^ sourceElement
]

{ #category : #accessing }
GtRenameMethodController >> sourceElement: textElement [
	sourceElement := textElement
]

{ #category : #private }
GtRenameMethodController >> uninstallPreviewEventHandlers [
	handlers isNil
		ifTrue: [ ^ self ].
	handlers do: [ :each | coder sourceEditor removeEventHandler: each ]
]
