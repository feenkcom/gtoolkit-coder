Class {
	#name : #RBRenameClassWithCommentsRefactoring,
	#superclass : #RBRenameClassRefactoring,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #transforming }
RBRenameClassWithCommentsRefactoring >> renameClassComments [
	self model
		allClassesDo: [ :each | 
			| newComment |
			each isMeta
				ifFalse: [ newComment := self renameClassInComment: each comment.
					newComment ~= each comment
						ifTrue: [ each comment: newComment ] ] ]
]

{ #category : #transforming }
RBRenameClassWithCommentsRefactoring >> renameClassInComment: aString [
	| index indices |
	aString isNil
		ifTrue: [ ^ nil ].
	(aString includesSubstring: className)
		ifFalse: [ ^ aString ].
	indices := OrderedCollection new.
	index := 1.
	[ index := aString indexOfSubCollection: className startingAt: index.
	index > 0 ]
		whileTrue: [ indices add: index.
			index := index + className size ].
	index := 1.
	^ String
		streamContents: [ :stream | 
			indices
				do: [ :each | 
					| isWord |
					stream nextPutAll: (aString copyFrom: index to: each - 1).
					index := each + className size.
					isWord := (each > 1 and: [ (aString at: each - 1) isAlphaNumeric ])
						not
						and: [ (index <= aString size and: [ (aString at: index) isAlphaNumeric ])
								not ].
					stream
						nextPutAll:
							(isWord
								ifTrue: [ newName ]
								ifFalse: [ className ]) ].
			stream nextPutAll: (aString copyFrom: index to: aString size) ]
]

{ #category : #transforming }
RBRenameClassWithCommentsRefactoring >> renameClassNameInMethodComments: aRBMethod [
	| comments index newSource originalSource |
	comments := OrderedCollection new.
	aRBMethod ast nodesDo: [ :each | comments addAll: each comments ].
	comments sort: [ :a :b | a start < b start ].
	originalSource := aRBMethod source.
	index := 1.
	newSource := String
		streamContents: [ :stream | 
			comments
				do: [ :each | 
					stream nextPutAll: (originalSource copyFrom: index to: each start).
					stream nextPutAll: (self renameClassInComment: each contents).
					index := each stop ].
			stream
				nextPutAll: (originalSource copyFrom: index to: originalSource size) ].
	newSource ~= originalSource
		ifTrue: [ aRBMethod methodClass compile: newSource ]
]

{ #category : #transforming }
RBRenameClassWithCommentsRefactoring >> renameMethodComments [
	self model
		allClassesDo: [ :cls | 
			cls selectors
				do: [ :sel | 
					| method |
					method := cls methodFor: sel.
					(method containsSubstring: className)
						ifTrue: [ self renameClassNameInMethodComments: method ] ] ]
]

{ #category : #transforming }
RBRenameClassWithCommentsRefactoring >> renameReferences [
	super renameReferences.
	self renameClassComments.
	self renameMethodComments
]
