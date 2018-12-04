Class {
	#name : #GtCoderMethodBodyElement,
	#superclass : #GtCoderMethodSourceElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodBodyElement >> actionsElement [
	^ GtCoderMethodActionsElement new 
		methodCoder: methodCoder;
		padding:
			(BlInsets
				top: 0
				left: -3
				bottom: -3
				right: 0)
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
