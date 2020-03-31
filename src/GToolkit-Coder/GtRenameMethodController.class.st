Class {
	#name : #GtRenameMethodController,
	#superclass : #Object,
	#instVars : [
		'coder',
		'sourceElement',
		'selector',
		'node',
		'model',
		'refactoring',
		'eventHandlers',
		'eventFilters',
		'renameAction',
		'originalSource'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #executing }
GtRenameMethodController >> acceptRename [
	self executeRefactoring
]

{ #category : #executing }
GtRenameMethodController >> cancelRename [
	^ sourceElement editor text: originalSource
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
	model := RBClassModelFactory rbNamespace onEnvironment: RBBrowserEnvironment new.
	model name: 'Rename method'.
	coder isModified
		ifTrue: [ self modelClass
				compile: coder newMethodSource asString
				classified: coder category ]
]

{ #category : #executing }
GtRenameMethodController >> execute [
	[ self saveSource.
	self createModel.
	self installRenamer ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #executing }
GtRenameMethodController >> executeRefactoring [
	| newSelector |
	newSelector := self someImplementor.
	newSelector = selector
		ifTrue: [ ^ self ].
	refactoring := RBRenameMethodRefactoring
		model: model
		renameMethod: selector
		in: newSelector
		to: self newSelectorName
		permutation: (1 to: selector numArgs).
	[ refactoring primitiveExecute ]
		on: RBRefactoringError
		do: [ :ex | ^ self cancelRename ].
	"for now just spawn the changes"
	sourceElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: model changes;
				sourceElement: sourceElement)
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
						ifTrue: [ renameAction := GtRenameAction
								locations: {interval}
								element: sourceElement.
							renameAction
								when: GtRenameActionAnnoucement
								do: [ :ann | 
									ann eventType = #cancel
										ifTrue: [ self cancelRename ].
									ann eventType = #accept
										ifTrue: [ self acceptRename ] ].
							renameAction install ] ] ]
]

{ #category : #testing }
GtRenameMethodController >> isRenaming [
	^ renameAction notNil and: [ renameAction isInstalled ]
]

{ #category : #private }
GtRenameMethodController >> modelClass [
	^ model classFor: coder classOrMetaClass
]

{ #category : #private }
GtRenameMethodController >> newSelectorName [
	| newAST |
	newAST := coder rbAST.
	node isMethod
		ifTrue: [ ^ newAST selector ].
	newAST
		nodesDo: [ :each | 
			(each isMessage
				and: [ each start = node start
						and: [ each arguments = node arguments
								and: [ each receiver = node receiver ] ] ])
				ifTrue: [ ^ each selector ] ].
	^ nil
]

{ #category : #executing }
GtRenameMethodController >> saveSource [
	originalSource := coder sourceEditor text copy
]

{ #category : #private }
GtRenameMethodController >> someImplementor [
	^ (model allImplementorsOf: selector)
		detect: [ :each | true ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtRenameMethodController >> sourceElement [
	^ sourceElement
]

{ #category : #accessing }
GtRenameMethodController >> sourceElement: textElement [
	sourceElement := textElement
]
