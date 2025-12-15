Class {
	#name : #GtSourceCoderCompileItShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : 'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderCompileItShortcut >> description [
	^ 'Compile class or trait definition'
]

{ #category : #initialization }
GtSourceCoderCompileItShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryS.
	name := 'Compile'.
]

{ #category : #evaluation }
GtSourceCoderCompileItShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel compileIt ]
]
