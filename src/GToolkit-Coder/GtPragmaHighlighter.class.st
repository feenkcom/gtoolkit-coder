Class {
	#name : #GtPragmaHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'symbol'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtPragmaHighlighter class >> forPragma: aSymbol [
	^ self new
		symbol: aSymbol;
		yourself
]

{ #category : #accessing }
GtPragmaHighlighter >> symbol [
	^ symbol
]

{ #category : #accessing }
GtPragmaHighlighter >> symbol: aSymbol [
	symbol := aSymbol
]

{ #category : #visiting }
GtPragmaHighlighter >> visitPragmaNode: aNode [
	super visitPragmaNode: aNode.
	aNode selector = symbol
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]
