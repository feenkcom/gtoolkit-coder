Class {
	#name : #GtSourceCoderMoveStatementDownShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> description [
	^ 'Moves a statement down in the statement list.'
]

{ #category : #initialization }
GtSourceCoderMoveStatementDownShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder primary arrowDown build.
	self coderShortcutId: GtCoderShortcutIds default moveStatementDownShortcutId
]

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> name [
	^ 'Move statement down'
]

{ #category : #accessing }
GtSourceCoderMoveStatementDownShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	aBrEditorElement
		selectedStringAndIntervalDo: [ :aSelectedString :aSelectionInterval | 
			aSourceCoderViewModel coder
				moveStatementsOrCascadesDownWithin: aSelectionInterval
				in: aSourceCoderViewModel ]
		orCursorPositionDo: [ :aCursorTextPosition | 
			aSourceCoderViewModel coder
				moveStatementOrCascadeDownAt: aCursorTextPosition
				in: aSourceCoderViewModel ]
]
