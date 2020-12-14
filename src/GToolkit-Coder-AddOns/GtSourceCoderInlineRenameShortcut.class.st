Class {
	#name : #GtSourceCoderInlineRenameShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #accessing }
GtSourceCoderInlineRenameShortcut >> description [
	^ 'Performs the rename refactoring of the selected variable/class/method.'
]

{ #category : #initialization }
GtSourceCoderInlineRenameShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryR
]

{ #category : #accessing }
GtSourceCoderInlineRenameShortcut >> name [
	^ 'Rename'
]

{ #category : #evaluation }
GtSourceCoderInlineRenameShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [

	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | aGtSourceCoder renameAt: aSelectionInterval last in: aBrEditorElement ]
		orCursorStringPositionDo: [ :aCursorTextPosition | aGtSourceCoder renameAt: aCursorTextPosition in: aBrEditorElement ]
]
