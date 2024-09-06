Class {
	#name : #GtSourceCoderDoItAsynchronousShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDoItAsynchronousShortcut >> description [
	^ 'Evaluates the whole source code (method) or just the selection.'
]

{ #category : #initialization }
GtSourceCoderDoItAsynchronousShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryD
]

{ #category : #accessing }
GtSourceCoderDoItAsynchronousShortcut >> name [
	^ 'Do it (asynchronous)'
]

{ #category : #evaluation }
GtSourceCoderDoItAsynchronousShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doItAsynchronous ]
]
