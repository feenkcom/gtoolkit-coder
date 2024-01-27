Class {
	#name : #GtSourceCoderBrowseImplementorsShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderBrowseImplementorsShortcut >> description [
	^ 'Browses implementors of the method near the cursor or selection.'
]

{ #category : #initialization }
GtSourceCoderBrowseImplementorsShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryM
]

{ #category : #accessing }
GtSourceCoderBrowseImplementorsShortcut >> name [
	^ 'Browse implementors'
]

{ #category : #evaluation }
GtSourceCoderBrowseImplementorsShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent requesterObject: aRequester [
	self
		forEditor: aBrTextEditor
		selectedStringDo: [ :aSelectedString | aGtSourceCoder browseImplementorsIn: aSelectedString requesterObject: aRequester ]
		orCursorStringPositionDo: [ :aStringPosition | aGtSourceCoder browseImplementorsAt: aStringPosition requesterObject: aRequester ]
]
