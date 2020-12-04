Class {
	#name : #GtSourceCoderPlayAndInspectShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderPlayAndInspectShortcut >> description [
	^ 'Compiles, saves and evaluates the whole source code (method) or just the selection and inspects the result.'
]

{ #category : #initialization }
GtSourceCoderPlayAndInspectShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryG
]

{ #category : #accessing }
GtSourceCoderPlayAndInspectShortcut >> name [
	^ 'Save, play and inspect'
]

{ #category : #evaluation }
GtSourceCoderPlayAndInspectShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ 
			"only execute if there is selection"
			aBrTextEditor hasSelection 
				ifTrue: [ GtSourceCoderDoItAndInspectShortcut new performDueTo: aShortcutEvent ] ]
]
