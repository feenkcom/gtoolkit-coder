Class {
	#name : #GtRenameMethodController,
	#superclass : #GtRenameController,
	#instVars : [
		'selector',
		'someImplementor'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #private }
GtRenameMethodController >> calculateNewNode [
	| newAST |
	newAST := coder rbAST.
	newAST isNil
		ifTrue: [ ^ self ].
	self originalNode isMethod
		ifTrue: [ ^ newNode := newAST ].
	newAST
		nodesDo: [ :each | 
			(each isMessage
				and: [ each start = self originalNode start
						and: [ each arguments = self originalNode arguments
								and: [ each receiver = self originalNode receiver ] ] ])
				ifTrue: [ newNode := each ] ]
]

{ #category : #executing }
GtRenameMethodController >> installRenamer [
	coder
		cursorPositionDo: [ :position | 
			selector := self originalNode selector.
			self someImplementor isNil
				ifTrue: [ ^ self ].
			self originalNode keywordsIntervals
				do: [ :interval | 
					(interval includes: position)
						ifTrue: [ self installRenamerOnInterval: interval.
							self installPreviewEventHandlers ] ] ]
]

{ #category : #private }
GtRenameMethodController >> newSelectorName [
	^ self newNode ifNotNil: [ :n | n selector ]
]

{ #category : #private }
GtRenameMethodController >> positionForPreview [
	^ self newNode ifNotNil: [ :ast | ast keywordsIntervals last last ]
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

{ #category : #private }
GtRenameMethodController >> someImplementor [
	^ someImplementor
		ifNil: [ (SystemNavigation default allImplementorsOf: selector)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :impls | someImplementor := impls anyOne methodClass ] ]
]
