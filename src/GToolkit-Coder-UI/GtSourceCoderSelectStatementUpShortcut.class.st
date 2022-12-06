Class {
	#name : #GtSourceCoderSelectStatementUpShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderSelectStatementUpShortcut >> description [
	^ 'Selects current statement or expands selection to previous statement.'
]

{ #category : #accessing }
GtSourceCoderSelectStatementUpShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder shift primary arrowUp build
]

{ #category : #accessing }
GtSourceCoderSelectStatementUpShortcut >> name [
	^ 'Selection statement up'
]

{ #category : #accessing }
GtSourceCoderSelectStatementUpShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | 
			aSourceCoderViewModel coder
				expandStatementSelection: aSelectionInterval
				upIn: aSourceCoderViewModel ]
		orCursorStringPositionDo: [ :aCursorTextPosition | 
			aSourceCoderViewModel coder
				selectStatementAt: aCursorTextPosition
				in: aSourceCoderViewModel ]
]
