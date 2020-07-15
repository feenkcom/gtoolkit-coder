Class {
	#name : #GtRefactoringChangesAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'refactoring'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #accessing }
GtRefactoringChangesAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [

	^ GtRefactoringsPreviewButton new
		refactorings: [ { refactoring } ]
]

{ #category : #initialization }
GtRefactoringChangesAttribute >> initialize [
	super initialize.
	self beAppend beNotOverwritableByStyler
]

{ #category : #accessing }
GtRefactoringChangesAttribute >> refactoring: aRBRefactoring [
	refactoring := aRBRefactoring
]
