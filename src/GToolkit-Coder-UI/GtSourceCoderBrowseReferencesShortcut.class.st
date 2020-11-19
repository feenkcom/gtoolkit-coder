Class {
	#name : #GtSourceCoderBrowseReferencesShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderBrowseReferencesShortcut >> description [
	^ 'Browses references of the class or sender of the method near the cursor or selection.'
]

{ #category : #initialization }
GtSourceCoderBrowseReferencesShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryN
]

{ #category : #accessing }
GtSourceCoderBrowseReferencesShortcut >> name [
	^ 'Browse references'
]

{ #category : #evaluation }
GtSourceCoderBrowseReferencesShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	self
		forEditor: aBrTextEditor
		selectedStringDo: [ :aSelectedString | aGtSourceCoder browseReferencesIn: aSelectedString ]
		orCursorStringPositionDo: [ :aStringPosition | aGtSourceCoder browseReferencesAt: aStringPosition ]
]
