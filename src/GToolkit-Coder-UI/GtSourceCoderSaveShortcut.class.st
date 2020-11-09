Class {
	#name : #GtSourceCoderSaveShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderSaveShortcut >> description [
	^ 'Apply changes and save the source code (compile).'
]

{ #category : #initialization }
GtSourceCoderSaveShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryS
]

{ #category : #accessing }
GtSourceCoderSaveShortcut >> name [
	^ 'Save'
]

{ #category : #evaluation }
GtSourceCoderSaveShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder save
]
