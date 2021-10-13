Class {
	#name : #GtSourceReferenceHighlighter,
	#superclass : #GtCoderAstStyler,
	#classVars : [
		'HighlightAttributes'
	],
	#category : 'GToolkit-Coder-Styler/Highlighter'
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
