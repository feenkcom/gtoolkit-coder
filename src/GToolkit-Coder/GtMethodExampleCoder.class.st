Class {
	#name : #GtMethodExampleCoder,
	#superclass : #GtMethodCoder,
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'as yet unclassified' }
GtMethodExampleCoder class >> forExample: anExample [
	^ self new example: anExample 
]

{ #category : #accessing }
GtMethodExampleCoder >> example [
	^ example
]

{ #category : #accessing }
GtMethodExampleCoder >> example: anObject [
	example := anObject
]

{ #category : #elements }
GtMethodExampleCoder >> patternButtonElement [
	| header patternElement label editorElement styledPattern |
	styledPattern := self styledPatternText.
	header := BrButton new.
	header
		layout: (BlGridLayout horizontal cellSpacing: 0);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	patternElement := BlElement new.
	patternElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c frame vertical alignCenter ].
	self patternEditor
		when: BrTextEditorInsertedEvent do: [ :event | self clearPatternSyntaxErrors ];
		when: BrTextEditorDeletedEvent do: [ :event | self clearPatternSyntaxErrors ].
	label := BlTextElement new.
	label text: styledPattern.
	label
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 5).
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	patternElement addChild: label.
	editorElement := BrEditorElement new.
	editorElement editor: self patternEditor.
	self patternEditor text: styledPattern.
	editorElement
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 5).
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editorElement when: BlClickEvent do: [ :event | event consumed: true ].
	editorElement visibility: BlVisibility hidden.
	patternElement addChild: editorElement.
	header addChild: patternElement.
	^ header
]
