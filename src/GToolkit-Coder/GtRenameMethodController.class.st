Class {
	#name : #GtRenameMethodController,
	#superclass : #GtRenameController,
	#instVars : [
		'selector',
		'someImplementor',
		'newSelectorParts',
		'selectorIndex'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #executing }
GtRenameMethodController >> installRenamer [
	coder
		cursorPositionDo: [ :position | 
			selector := self originalNode selector.
			self someImplementor isNil
				ifTrue: [ ^ self ].
			newSelectorParts := selector keywords.
			self originalNode keywordsIntervals
				keysAndValuesDo: [ :i :interval | 
					(interval includes: position)
						ifTrue: [ selectorIndex := i.
							newName := newSelectorParts at: i.
							renameInterval := interval.
							self installRenameAction ] ] ]
]

{ #category : #accessing }
GtRenameMethodController >> newName [
	^ self newSelectorName
]

{ #category : #private }
GtRenameMethodController >> newSelectorName [
	selector numArgs = 0
		ifTrue: [ ^ newName asSymbol ].
	^ (String
		streamContents: [ :stream | 
			1 to: selector numArgs do: [ :i | 
				stream
					nextPutAll:
						(selectorIndex = i
							ifTrue: [ newName ]
							ifFalse: [ newSelectorParts at: i ]) ] ]) asSymbol
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

{ #category : #private }
GtRenameMethodController >> someImplementor [
	^ someImplementor
		ifNil: [ (SystemNavigation default allImplementorsOf: selector)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :impls | someImplementor := impls anyOne methodClass ] ]
]
