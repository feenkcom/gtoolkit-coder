Class {
	#name : #GtSourceCoderSearchTextShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderSearchTextShortcut >> description [
	^ 'Search text'
]

{ #category : #initialization }
GtSourceCoderSearchTextShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryF
]

{ #category : #accessing }
GtSourceCoderSearchTextShortcut >> name [
	^ 'Search'
]

{ #category : #evaluation }
GtSourceCoderSearchTextShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	aSourceCoderViewModel requestSearch
]
