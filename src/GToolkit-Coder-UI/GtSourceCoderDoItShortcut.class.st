Class {
	#name : #GtSourceCoderDoItShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDoItShortcut >> description [
	^ 'Evaluates the whole source code (method) or just the selection.'
]

{ #category : #initialization }
GtSourceCoderDoItShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryD
]

{ #category : #accessing }
GtSourceCoderDoItShortcut >> name [
	^ 'Do it'
]

{ #category : #evaluation }
GtSourceCoderDoItShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder doItSelectionOrAllFrom: aBrEditorElement
]
