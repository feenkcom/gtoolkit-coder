Class {
	#name : #GtSourceCoderDebugShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDebugShortcut >> description [
	^ 'Opens a debugger on the evaluation of the whole source code or just the selection.'
]

{ #category : #initialization }
GtSourceCoderDebugShortcut >> initialize [
	super initialize.

	combination := BlKeyCombinationBuilder new primary shift d build.
	self coderShortcutId: GtCoderShortcutIds default debugShortcutId
]

{ #category : #accessing }
GtSourceCoderDebugShortcut >> name [
	^ 'Debug'
]

{ #category : #accessing }
GtSourceCoderDebugShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel debug ]
]
