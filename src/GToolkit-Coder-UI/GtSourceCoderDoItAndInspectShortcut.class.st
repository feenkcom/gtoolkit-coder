Class {
	#name : #GtSourceCoderDoItAndInspectShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDoItAndInspectShortcut >> description [
	^ 'Evaluates the whole source code or just the selection and inspects the result.'
]

{ #category : #initialization }
GtSourceCoderDoItAndInspectShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryG
]

{ #category : #accessing }
GtSourceCoderDoItAndInspectShortcut >> name [
	^ 'Do it and inspect'
]

{ #category : #evaluation }
GtSourceCoderDoItAndInspectShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doItAndGo ]
]
