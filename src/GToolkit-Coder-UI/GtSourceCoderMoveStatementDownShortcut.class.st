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
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | 
			aSourceCoderViewModel coder
				moveStatementsOrCascadesDownWithin: aSelectionInterval
				in: aSourceCoderViewModel ]
		orCursorStringPositionDo: [ :aCursorTextPosition | 
			aSourceCoderViewModel coder
				moveStatementOrCascadeDownAt: aCursorTextPosition
				in: aSourceCoderViewModel ]
]
