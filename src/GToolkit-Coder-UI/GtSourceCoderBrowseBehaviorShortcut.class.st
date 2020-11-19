Class {
	#name : #GtSourceCoderBrowseBehaviorShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderBrowseBehaviorShortcut >> description [
	^ 'Browses behavior (class, method, pool etc) near the cursor or selection.'
]

{ #category : #initialization }
GtSourceCoderBrowseBehaviorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryB
]

{ #category : #accessing }
GtSourceCoderBrowseBehaviorShortcut >> name [
	^ 'Browse behavior'
]

{ #category : #evaluation }
GtSourceCoderBrowseBehaviorShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [

	self
		forEditor: aBrTextEditor
		selectedStringDo: [ :aSelectedString | aGtSourceCoder browseBehaviorIn: aSelectedString ]
		orCursorStringPositionDo: [ :aStringPosition | aGtSourceCoder browseBehaviorAt: aStringPosition ]
]
