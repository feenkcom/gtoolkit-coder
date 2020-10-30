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
	HighlightAttributes := {
		BlTextDecorationAttribute new
			underline;
			color: BrGlamorousColors textHighlightColor;
			thickness: 3
	}
]
