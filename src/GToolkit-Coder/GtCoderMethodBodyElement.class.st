Class {
	#name : #GtCoderMethodBodyElement,
	#superclass : #GtCoderMethodSourceElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodBodyElement >> actionsElement [
	^ GtCoderActionsElement new 
		coder: methodCoder;
		padding:
			(BlInsets
				top: 0
				left: -3
				bottom: -3
				right: 0)
]

{ #category : #initialization }
GtCoderMethodBodyElement >> editorElement [
	| element anEditorElement |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	anEditorElement := BrEditorElement new.
	anEditorElement padding: (BlInsets top: 0 left: 0 bottom: 2 right: 0).
	anEditorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	anEditorElement editor: methodCoder sourceEditor.
	methodCoder addShortcutsTo: anEditorElement.
	(GtCompletionController on: anEditorElement strategy: methodCoder completionStrategy) install.
	element addChild: anEditorElement.
	^ element
]
