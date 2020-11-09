Class {
	#name : #GtSourceCoderFormatShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderFormatShortcut >> description [
	^ 'Formats and saves the source code.'
]

{ #category : #initialization }
GtSourceCoderFormatShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftF
]

{ #category : #accessing }
GtSourceCoderFormatShortcut >> name [
	^ 'Format'
]

{ #category : #evaluation }
GtSourceCoderFormatShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	aGtSourceCoder format
]
