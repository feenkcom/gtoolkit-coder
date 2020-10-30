Class {
	#name : #GtRefactoringChangesAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'refactoring',
		'completionAction'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #initialization }
GtRefactoringChangesAttribute >> completionAction: aBlock [
	completionAction := aBlock
]

{ #category : #accessing }
GtRefactoringChangesAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ GtRefactoringsPreviewButton new
		refactorings: [ {refactoring} ];
		when: GtRefactoringsAppliedEvent
			do: [ :event | 
			completionAction notNil
				ifTrue: [ completionAction cull: event ] ]
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
