Class {
	#name : #GtCoderMethodPatternElement,
	#superclass : #GtCoderMethodSourceElement,
	#instVars : [
		'toolbar',
		'label'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderMethodPatternElement >> editorElement [
	label := BrEditorElement new.
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	label editor: methodCoder collapsedEditor.
	^ label
]
