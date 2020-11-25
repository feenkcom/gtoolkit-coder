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
GtSourceCoderDoItAndInspectShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [
			aBrTextEditor hasSelection 
				ifTrue: [
					aGtSourceCoder doItAndGo: [ :aSourceText |
						aBrTextEditor text characters = aSourceText characters
							ifTrue: [ self selectionIntervalIn: aBrTextEditor ]
							ifFalse: [
								self flag: 'Handle modified text here'.
								1 to: 0 ] ] ] 
				ifFalse: [ aGtSourceCoder doItAndGoAll ] ]
]
