Class {
	#name : #GtSelectorReferenceHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtSelectorReferenceHighlighter class >> forSelector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #accessing }
GtSelectorReferenceHighlighter >> selector [
	^ selector
]

{ #category : #accessing }
GtSelectorReferenceHighlighter >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #visiting }
GtSelectorReferenceHighlighter >> visitLiteralNode: aNode [
	super visitLiteralNode: aNode.
	aNode value = selector
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]

{ #category : #visiting }
GtSelectorReferenceHighlighter >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	aMessageNode selector = selector
		ifTrue: [ aMessageNode selectorParts
				with: aMessageNode keywordsPositions
				do: [ :keyword :position | self styleFrom: position to: position + keyword size - 1 with: HighlightAttributes ] ]
]
