Class {
	#name : #GtSourceCoderPlayShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderPlayShortcut >> description [
	^ 'Compiles, saves and evaluates the whole source code (method) or just the selection.'
]

{ #category : #initialization }
GtSourceCoderPlayShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryD
]

{ #category : #accessing }
GtSourceCoderPlayShortcut >> name [
	^ 'Save and play'
]

{ #category : #evaluation }
GtSourceCoderPlayShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [	
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [
			"only execute if there is selection"
			aBrTextEditor hasSelection 
				ifTrue: [ GtSourceCoderDoItShortcut new performDueTo: aShortcutEvent ] ]
]
