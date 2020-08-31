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
		paint: BrGlamorousColors textHighlightColor;
		thickness: 3)}
]
