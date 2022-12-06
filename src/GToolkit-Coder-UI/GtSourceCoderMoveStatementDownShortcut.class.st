Class {
	#name : #GtSourceCoderMoveStatementDownShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> description [
	^ 'Moves a statement down in the statement list.'
]

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder primary arrowDown build
]

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> name [
	^ 'Move statement down'
]

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	| pos |
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | pos := aSelectionInterval last ]
		orCursorStringPositionDo: [ :aCursorTextPosition | pos := aCursorTextPosition ].
	pos
		ifNotNil: [ aSourceCoderViewModel coder moveStatementDownAt: pos in: aSourceCoderViewModel ]
]
