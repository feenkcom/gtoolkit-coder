Class {
	#name : #GtSourceCoderRenameShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderRenameShortcut >> description [
	^ 'Performs the rename refactoring of the selected variable/class/method.'
]

{ #category : #initialization }
GtSourceCoderRenameShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryR
]

{ #category : #accessing }
GtSourceCoderRenameShortcut >> name [
	^ 'Rename'
]

{ #category : #evaluation }
GtSourceCoderRenameShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder renameIn: aBrEditorElement
]
