Class {
	#name : #GtSourceCoderSelectStatementDownShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> description [
	^ 'Selects current statement or expands selection to next statement.'
]

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder shift primary arrowDown build
]

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> name [
	^ 'Selection statement down'
]

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | 
			aSourceCoderViewModel coder
				expandStatementSelection: aSelectionInterval
				downIn: aSourceCoderViewModel ]
		orCursorStringPositionDo: [ :aCursorTextPosition | 
			aSourceCoderViewModel coder
				selectStatementOrCascadeAt: aCursorTextPosition
				in: aSourceCoderViewModel ]
]
