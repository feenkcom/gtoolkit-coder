Class {
	#name : #GtCoderMethodBodyElement,
	#superclass : #GtCoderMethodSourceElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodBodyElement >> actionsElement [
	^ GtCoderMethodActionsElement new methodCoder: methodCoder
]

{ #category : #initialization }
GtCoderMethodBodyElement >> editorElement [
	| anEditorElement |
	anEditorElement := BrEditorElement new.
	anEditorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	anEditorElement editor: methodCoder sourceEditor.
	methodCoder addShortcutsTo: anEditorElement.
	(GtCompletionController on: anEditorElement strategy: methodCoder newCompletionStrategy) install.
	^ anEditorElement
]
