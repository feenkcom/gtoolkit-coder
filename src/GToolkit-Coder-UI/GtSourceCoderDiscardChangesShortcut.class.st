Class {
	#name : #GtSourceCoderDiscardChangesShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDiscardChangesShortcut >> description [
	^ 'Discards changes done to the source code.'
]

{ #category : #initialization }
GtSourceCoderDiscardChangesShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryL
]

{ #category : #accessing }
GtSourceCoderDiscardChangesShortcut >> name [
	^ 'Discard changes'
]

{ #category : #evaluation }
GtSourceCoderDiscardChangesShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder discardChanges
]
