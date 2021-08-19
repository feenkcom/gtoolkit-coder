Class {
	#name : 'GtCompositeHighlighter',
	#superclass : 'GtSourceReferenceHighlighter',
	#instVars : [
		'highlighters'
	],
	#category : 'GToolkit-Coder-Styler/Highlighter'
}

{ #category : 'instance creation' }
GtCompositeHighlighter class >> forHighlighters: aCollection [
	^ self new
		forHighlighters: aCollection;
		yourself
]

{ #category : 'initialize-release' }
GtCompositeHighlighter >> forHighlighters: aCollection [
	highlighters := aCollection
]

{ #category : 'styling' }
GtCompositeHighlighter >> style: aText ast: ast [
	highlighters do: [ :each | each style: aText ast: ast ]
]
