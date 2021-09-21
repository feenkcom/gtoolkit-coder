Class {
	#name : 'GtRenameMethodController',
	#superclass : 'GtRenameController',
	#instVars : [
		'selector',
		'someImplementor',
		'newSelectorParts',
		'selectorIndex',
		'startIndex',
		'previewIndex'
	],
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'executing' }
GtRenameMethodController >> installRenamer [
	self
		cursorPositionDo: [ :position | 
			| message |
			selector := self originalNode selector.
			self someImplementor isNil
				ifTrue: [ ^ self ].

			startIndex := self originalNode selectorParts first startPosition.
			newSelectorParts := selector keywords.
			message := self originalNode.
			message selectorParts
				keysAndValuesDo: [ :i :eachSmaCCToken | 
					(eachSmaCCToken sourceInterval includes: position)
						ifTrue: [
							selectorIndex := i.
							self installRenamerOn: message ] ] ]
]

{ #category : 'executing' }
GtRenameMethodController >> installRenamerOn: aGtPharoMessageNode [
	previewIndex := node selectorParts last stopPosition.
	newName := newSelectorParts at: selectorIndex.
	renameInterval := (aGtPharoMessageNode selectorParts at: selectorIndex) sourceInterval.
	self installRenameAction
]

{ #category : 'accessing' }
GtRenameMethodController >> installValidation [
	| argCount |
	argCount := selector numArgs.
	argCount = 0
		ifTrue: [ ^ super installValidation ].
	argCount = 1
		ifTrue: [ renameAction forBinaryOrKeyword ]
		ifFalse: [ renameAction forKeyword ]
]

{ #category : 'accessing' }
GtRenameMethodController >> newName [
	^ self newSelectorName
]

{ #category : 'private' }
GtRenameMethodController >> newNode [
	sourceCoderViewModel astAwait nodesDo: [ :each | 
		((each isMessage or: [ each isMethod or: [ each isMethodPattern ] ])
			and: [ each selectorParts first startPosition = startIndex ])
			ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : 'private' }
GtRenameMethodController >> newSelectorName [
	selector numArgs = 0
		ifTrue: [ ^ newName asSymbol ].
	^ (String
		streamContents:
			[ :stream | newSelectorParts do: [ :each | stream nextPutAll: each ] ])
		asSymbol
]

{ #category : 'accessing' }
GtRenameMethodController >> originalName [
	^ selector
]

{ #category : 'private' }
GtRenameMethodController >> refactoring [
	| implementor newSelector model |
	implementor := self someImplementor.
	implementor isNil
		ifTrue: [ ^ nil ].
	newSelector := self newSelectorName.
	newSelector = selector
		ifTrue: [ ^ nil ].
	model := self createModel.
	^ (GtCoderRenameMethodRefactoring
		model: model
		renameMethod: selector
		in: (model classFor: implementor)
		to: newSelector
		permutation: (1 to: selector numArgs))
			methodCoder: sourceCoderViewModel coderModel
]

{ #category : 'accessing' }
GtRenameMethodController >> refactoringName [
	^ 'Rename method'
]

{ #category : 'accessing' }
GtRenameMethodController >> renamePosition [
	self newNode
		ifNotNil: [ :message | ^ message selectorParts last stopPosition ].
	^ (renameAction isNil or: [ renameAction isInstalled ])
		ifTrue: [ previewIndex ]
		ifFalse: [ self originalNode selectorParts last stopPosition + self newName size
				- self originalName size ]
]

{ #category : 'private' }
GtRenameMethodController >> someImplementor [
	^ someImplementor
		ifNil: [ (SystemNavigation default allImplementorsOf: selector)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :impls | someImplementor := impls anyOne methodClass ] ]
]

{ #category : 'private' }
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
			self removeRefactoringAttribute.
			self sourceCoderViewModel moveCursorTo: (message selectorParts at: selectorIndex) stopPosition.
			self installRenamerOn: message.
			newSelectorParts = selector keywords
				ifFalse: [ self addRefactoringChangesPreview ] ]
]

{ #category : 'private' }
GtRenameMethodController >> updateName: aString [

	"we should update selector parts before updating the name, otherwise the refactoring will be canceled"
	newSelectorParts at: selectorIndex put: aString.
	super updateName: aString
]
