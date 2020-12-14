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
		beMiniSize;
		vMatchParent;
		refactorings: [ {refactoring} ];
		margin: (BlInsets top: 1 right: 4 bottom: 0 left: 4);
		when: GtRefactoringsAppliedEvent
			do: [ :event | 
			completionAction notNil
				ifTrue: [ completionAction cull: event ] ]
]

{ #category : #initialization }
GtRefactoringChangesAttribute >> initialize [
	super initialize.
	self beAppend.
	self beNotOverwritableByStyler
]

{ #category : #accessing }
GtRefactoringChangesAttribute >> refactoring: aRBRefactoring [
	refactoring := aRBRefactoring
]
