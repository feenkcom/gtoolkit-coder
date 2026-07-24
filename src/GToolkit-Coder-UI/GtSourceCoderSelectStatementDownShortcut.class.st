Class {
	#name : #GtSourceCoderSelectStatementDownShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> description [
	^ 'Selects current statement or expands selection to next statement.'
]

{ #category : #initialization }
GtSourceCoderSelectStatementDownShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder shift primary arrowDown build.
	self coderShortcutId: GtCoderShortcutIds default selectStatementDownShortcutId
]

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> name [
	^ 'Selection statement down'
]

{ #category : #accessing }
GtSourceCoderSelectStatementDownShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	aBrEditorElement
		selectedStringAndIntervalDo: [ :aSelectedString :aSelectionInterval | 
			aSourceCoderViewModel coder
				expandStatementSelection: aSelectionInterval
				downIn: aSourceCoderViewModel ]
		orCursorPositionDo: [ :aCursorTextPosition | 
			aSourceCoderViewModel coder
				selectStatementOrCascadeAt: aCursorTextPosition
				in: aSourceCoderViewModel ]
]
