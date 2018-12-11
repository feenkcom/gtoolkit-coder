Class {
	#name : #GtSourceReferenceHighlighter,
	#superclass : #GtCoderBodyStyler,
	#classVars : [
		'HighlightAttributes'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'class initialization' }
GtSourceReferenceHighlighter class >> initialize [
	HighlightAttributes := {(BlTextUnderlineAttribute new
		paint: BrGlamorousColors textHighlightColor;
		width: 3)}
]
