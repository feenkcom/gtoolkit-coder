Class {
	#name : #GtSourceCoderShortcut,
	#superclass : #BrEditorShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #evaluation }
GtSourceCoderShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	self subclassResponsibility
]

{ #category : #evaluation }
GtSourceCoderShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement dueTo: aShortcutEvent [
	aBrTextEditor model ifNotNil: [ :aSourceCoder |
		self performOnEditor: aBrTextEditor element: aBrEditorElement coder: aSourceCoder dueTo: aShortcutEvent ]
]
