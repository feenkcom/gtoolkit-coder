Class {
	#name : #GtRenameVariableController,
	#superclass : #GtRenameController,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #private }
GtRenameVariableController >> calculateNewNode [
	| newAST |
	newAST := coder rbAST.
	newAST isNil
		ifTrue: [ ^ self ].
	newAST
		nodesDo: [ :each | 
			(each isVariable and: [ each start = self originalNode start ])
				ifTrue: [ newNode := each ] ]
]

{ #category : #executing }
GtRenameVariableController >> installRenamer [
	self originalNode isNil
		ifTrue: [ ^ self ].
	self installRenamerOnInterval: self originalNode sourceInterval.
	self installPreviewEventHandlers
]

{ #category : #accessing }
GtRenameVariableController >> refactoring [
	self newNode isNil
		ifTrue: [ ^ nil ].
	self originalNode = self newNode
		ifTrue: [ ^ nil ].
	^ self rename: self originalNode name to: self newNode name
]

{ #category : #accessing }
GtRenameVariableController >> rename: oldName to: newName [
	^ self subclassResponsibility
]
