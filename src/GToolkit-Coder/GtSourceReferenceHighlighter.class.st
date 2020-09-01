Class {
	#name : #GtSourceReferenceHighlighter,
	#superclass : #GtASTStyler,
	#classVars : [
		'HighlightAttributes'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'class initialization' }
GtSourceReferenceHighlighter class >> initialize [
	HighlightAttributes := {(BlTextUnderlineAttribute new
		color: BrGlamorousColors textHighlightColor;
		thickness: 3)}
]
