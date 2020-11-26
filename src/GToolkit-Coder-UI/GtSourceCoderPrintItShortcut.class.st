Class {
	#name : #GtSourceCoderPrintItShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderPrintItShortcut >> description [
	^ 'Evaluates the whole source code (method) or just the selection and prints it in the editor.'
]

{ #category : #initialization }
GtSourceCoderPrintItShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryP
]

{ #category : #accessing }
GtSourceCoderPrintItShortcut >> name [
	^ 'Print'
]

{ #category : #evaluation }
GtSourceCoderPrintItShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [
			aBrTextEditor hasSelection 
				ifTrue: [ aGtSourceCoder printItWithin: [ :aSourceText |
					aBrTextEditor text characters = aSourceText characters
						ifTrue: [ self selectionIntervalIn: aBrTextEditor ]
						ifFalse: [
							self flag: 'Handle modified text here'.
							1 to: 0 ] ] ] 
				ifFalse: [ aGtSourceCoder printItAll ] ]
]
