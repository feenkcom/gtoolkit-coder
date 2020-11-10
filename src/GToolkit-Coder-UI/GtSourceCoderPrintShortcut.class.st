Class {
	#name : #GtSourceCoderPrintShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderPrintShortcut >> description [
	^ 'Evaluates the whole source code (method) or just the selection and prints it in the editor.'
]

{ #category : #initialization }
GtSourceCoderPrintShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryP
]

{ #category : #accessing }
GtSourceCoderPrintShortcut >> name [
	^ 'Print'
]

{ #category : #evaluation }
GtSourceCoderPrintShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder printItSelectionFrom: aBrEditorElement
]
