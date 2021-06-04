"
RBRenameClassWithCommentsRefactoringExamples  test first character
(RBRenameClassWithCommentsRefactoringExamples)  should be renamed
RBRenameClassWithCommentsRefactoringExamplesTest  should not be renamed as it ends with Test
TestRBRenameClassWithCommentsRefactoringExamples  should not be renamed as it starts with Test
test last character -- RBRenameClassWithCommentsRefactoringExamples


"
Class {
	#name : #RBRenameClassWithCommentsRefactoringExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Refactorings'
}

{ #category : #examples }
RBRenameClassWithCommentsRefactoringExamples >> renameClassComment [
	"This comment with RBRenameClassWithCommentsRefactoringExamples should be renamed"

	<noTest>
	<gtExample>
	| model refactoring cls newName |
	model := RBNamespace new.
	cls := model classFor: RBRenameClassWithCommentsRefactoringExamples.
	self assert: cls comment = self class comment.
	newName := #RenamedExample.
	refactoring := RBRenameClassWithCommentsRefactoring
		model: model
		rename: cls
		to: newName.
	refactoring primitiveExecute.
	self assert: cls comment ~= self class comment.
	self class comment lines
		with: cls comment lines
		do: [ :orig :new | 
			(orig includesSubstring: ' not ')
				ifTrue: [ self assert: orig = new ]
				ifFalse: [ self
						assert: (orig copyReplaceAll: self class name with: newName) = new ] ].
	self
		assert:
			(cls methodFor: thisContext method selector) source
				=
					(thisContext method sourceCode
						copyReplaceAll: self class name
						with: newName).
	^ model	"This should also be renamed since it contains RBRenameClassWithCommentsRefactoringExamples"
]
