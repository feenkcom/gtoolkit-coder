Class {
	#name : #GtRenameMethodController,
	#superclass : #GtRenameController,
	#instVars : [
		'selector',
		'someImplementor',
		'newSelectorParts',
		'selectorIndex',
		'startIndex',
		'previewIndex'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #executing }
GtRenameMethodController >> canceled [
	super canceled.
	self restoreText
]

{ #category : #executing }
GtRenameMethodController >> installRenamer [
	coder
		cursorPositionDo: [ :position | 
			| message |
			selector := self originalNode selector.
			self someImplementor isNil
				ifTrue: [ ^ self ].
			startIndex := self originalNode keywordsIntervals first first.
			newSelectorParts := selector keywords.
			message := self originalNode.
			message keywordsIntervals
				keysAndValuesDo: [ :i :interval | 
					(interval includes: position)
						ifTrue: [ selectorIndex := i.
							self installRenamerOn: message ] ] ]
]

{ #category : #executing }
GtRenameMethodController >> installRenamerOn: aRBMessageNode [
	previewIndex := node keywordsIntervals last last.
	newName := newSelectorParts at: selectorIndex.
	renameInterval := aRBMessageNode keywordsIntervals at: selectorIndex.
	self installRenameAction
]

{ #category : #accessing }
GtRenameMethodController >> installValidation [
	| argCount |
	argCount := selector numArgs.
	argCount = 0
		ifTrue: [ ^ super installValidation ].
	argCount = 1
		ifTrue: [ renameAction forBinaryOrKeyword ]
		ifFalse: [ renameAction forKeyword ]
]

{ #category : #accessing }
GtRenameMethodController >> newName [
	^ self newSelectorName
]

{ #category : #private }
GtRenameMethodController >> newNode [
	coder rbAST
		ifNotNil: [ :ast | 
			ast
				nodesDo: [ :each | 
					((each isMessage or: [ each isMethod ])
						and: [ each keywordsIntervals first first = startIndex ])
						ifTrue: [ ^ each ] ] ].
	^ nil
]

{ #category : #private }
GtRenameMethodController >> newSelectorName [
	selector numArgs = 0
		ifTrue: [ ^ newName asSymbol ].
	^ (String
		streamContents:
			[ :stream | newSelectorParts do: [ :each | stream nextPutAll: each ] ])
		asSymbol
]

{ #category : #accessing }
GtRenameMethodController >> originalName [
	^ selector
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

{ #category : #accessing }
GtRenameMethodController >> refactoringName [
	^ 'Rename method'
]

{ #category : #accessing }
GtRenameMethodController >> renamePosition [
	self newNode
		ifNotNil: [ :message | ^ message keywordsIntervals last last ].
	^ (renameAction isNil or: [ renameAction isInstalled ])
		ifTrue: [ previewIndex ]
		ifFalse: [ self originalNode keywordsIntervals last last + self newName size
				- self originalName size ]
]

{ #category : #private }
GtRenameMethodController >> someImplementor [
	^ someImplementor
		ifNil: [ (SystemNavigation default allImplementorsOf: selector)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :impls | someImplementor := impls anyOne methodClass ] ]
]

{ #category : #private }
GtRenameMethodController >> tab: forward [
	self originalNode arguments size < 2
		ifTrue: [ ^ self ].
	forward
		ifTrue: [ selectorIndex := selectorIndex + 1.
			selectorIndex > self originalNode arguments size
				ifTrue: [ selectorIndex := 1 ] ]
		ifFalse: [ selectorIndex := selectorIndex - 1.
			selectorIndex = 0
				ifTrue: [ selectorIndex := self originalNode arguments size ] ].
	self newNode
		ifNotNil: [ :message | 
			coder removeRefactoringAttribute.
			coder sourceEditor
				moveCursorTo: (message keywordsIntervals at: selectorIndex) last.
			self installRenamerOn: message.
			newSelectorParts = selector keywords
				ifFalse: [ self addRefactoringChangesPreview ] ]
]

{ #category : #private }
GtRenameMethodController >> updateName: aString [
	super updateName: aString.
	newSelectorParts at: selectorIndex put: aString
]
