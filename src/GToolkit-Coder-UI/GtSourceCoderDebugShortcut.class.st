Class {
	#name : #GtSourceCoderDebugShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDebugShortcut >> description [
	^ 'Opens a debugger on the evaluation of the whole source code or just the selection.'
]

{ #category : #accessing }
GtSourceCoderDebugShortcut >> initialize [
	super initialize.

	combination := BlKeyCombinationBuilder new primary shift d build
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
