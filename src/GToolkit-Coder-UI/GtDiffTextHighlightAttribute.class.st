"
Resolves a diff fragment's themeable background color against the theme of the text editor.
"
Class {
	#name : #GtDiffTextHighlightAttribute,
	#superclass : #BlTextHighlightAttribute,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #accessing }
GtDiffTextHighlightAttribute >> applyOnFontAndStyleBuilder: aBuilder theme: aTheme [
	aBuilder background: (self paint blocResolveColorForTheme: aTheme)
]
