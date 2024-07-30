Class {
	#name : #GtRBRenameMethodRefactoring,
	#superclass : #RBRenameMethodRefactoring,
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #accessing }
GtRBRenameMethodRefactoring >> executeRenameExtensions [
	(Pragma
		allNamed: #gtRename
		from: self class
		to: GtRBRenameMethodRefactoring)
		do: [ :each | self perform: each method selector ]
]

{ #category : #accessing }
GtRBRenameMethodRefactoring >> renameMessageSends [
	super renameMessageSends.
	self executeRenameExtensions
]
