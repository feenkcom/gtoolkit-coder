Class {
	#name : #GtSourceCoderExtractMethodShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderExtractMethodShortcut >> description [
	^ 'Extracts the selected code into a new method.'
]

{ #category : #initialization }
GtSourceCoderExtractMethodShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryE
]

{ #category : #accessing }
GtSourceCoderExtractMethodShortcut >> name [
	^ 'Extract method'
]

{ #category : #evaluation }
GtSourceCoderExtractMethodShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder extractMethod: aBrEditorElement
]
