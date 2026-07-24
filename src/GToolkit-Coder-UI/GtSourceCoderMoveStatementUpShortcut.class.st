Class {
	#name : #GtSourceCoderMoveStatementUpShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> description [
	^ 'Moves a statement up in the statement list.'
]

{ #category : #initialization }
GtSourceCoderMoveStatementUpShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder primary arrowUp build.
	self coderShortcutId: GtCoderShortcutIds default moveStatementUpShortcutId
]

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> name [
	^ 'Move statement up'
]

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	aBrEditorElement
		selectedStringAndIntervalDo: [ :aSelectedString :aSelectionInterval | 
			aSourceCoderViewModel coder
				moveStatementsOrCascadesUpWithin: aSelectionInterval
				in: aSourceCoderViewModel ]
		orCursorPositionDo: [ :aCursorTextPosition | 
			aSourceCoderViewModel coder
				moveStatementOrCascadeUpAt: aCursorTextPosition
				in: aSourceCoderViewModel ]
]
