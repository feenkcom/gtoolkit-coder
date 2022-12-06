Class {
	#name : #GtSourceCoderMoveStatementUpShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> description [
	^ 'Moves a statement up in the statement list.'
]

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder primary arrowUp build
]

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> name [
	^ 'Move statement up'
]

{ #category : #accessing }
GtSourceCoderMoveStatementUpShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	| pos |
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | pos := aSelectionInterval last ]
		orCursorStringPositionDo: [ :aCursorTextPosition | pos := aCursorTextPosition ].
	pos
		ifNotNil: [ aSourceCoderViewModel coder moveStatementUpAt: pos in: aSourceCoderViewModel ]
]
