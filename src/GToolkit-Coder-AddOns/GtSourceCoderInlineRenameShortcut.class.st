Class {
	#name : 'GtSourceCoderInlineRenameShortcut',
	#superclass : 'GtSourceCoderShortcut',
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'accessing' }
GtSourceCoderInlineRenameShortcut >> description [
	^ 'Performs the rename refactoring of the selected variable/class/method.'
]

{ #category : 'initialization' }
GtSourceCoderInlineRenameShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryR
]

{ #category : 'accessing' }
GtSourceCoderInlineRenameShortcut >> name [
	^ 'Rename'
]

{ #category : 'evaluation' }
GtSourceCoderInlineRenameShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | aSourceCoderViewModel coder renameAt: aSelectionInterval last in: aSourceCoderViewModel ]
		orCursorStringPositionDo: [ :aCursorTextPosition | aSourceCoderViewModel coder renameAt: aCursorTextPosition in: aSourceCoderViewModel ]
]
