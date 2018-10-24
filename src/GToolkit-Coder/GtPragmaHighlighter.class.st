Class {
	#name : #GtPragmaHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'symbol'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtPragmaHighlighter class >> forPragma: aSymbol [
	^ self new
		symbol: aSymbol;
		yourself
]

{ #category : #testing }
GtPragmaHighlighter >> shouldHighlight: aNode [
	^ (aNode isKindOf: RBPragmaNode) and: [ aNode selector = symbol ]
]

{ #category : #accessing }
GtPragmaHighlighter >> symbol [
	^ symbol
]

{ #category : #accessing }
GtPragmaHighlighter >> symbol: aSymbol [
	symbol := aSymbol
]
