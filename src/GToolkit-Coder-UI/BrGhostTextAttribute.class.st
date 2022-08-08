Class {
	#name : #BrGhostTextAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Attributes'
}

{ #category : #accessing }
BrGhostTextAttribute class >> for: aText [
	^ self new
		for: aText;
		beAppend;
		beNotOverwritableByStyler;
		withoutCache;
		yourself
]

{ #category : #accessing }
BrGhostTextAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| element |
	element := BlTextElement new
			text: text;
			yourself.
	anEditorElement text isEmpty ifFalse: [ element size: 0 @ 0 ].
	^ element
]

{ #category : #accessing }
BrGhostTextAttribute >> for: aText [
	text := aText
]
