Class {
	#name : #GtSourceCoderPrintItShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderPrintItShortcut >> description [
	^ 'Evaluates the whole source code (method) or just the selection and prints it in the editor.'
]

{ #category : #initialization }
GtSourceCoderPrintItShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryP.
	name := 'Print'.
	self coderShortcutId: GtCoderShortcutIds default printItShortcutId
]

{ #category : #evaluation }
GtSourceCoderPrintItShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aGtSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aGtSourceCoderViewModel printIt ]
]
