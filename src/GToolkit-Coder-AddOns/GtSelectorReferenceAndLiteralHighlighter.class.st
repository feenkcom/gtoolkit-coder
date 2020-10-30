Class {
	#name : #GtSelectorReferenceAndLiteralHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-AddOns-Reference highlighter'
}

{ #category : #'instance creation' }
GtSelectorReferenceAndLiteralHighlighter class >> forSelector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #accessing }
GtSelectorReferenceAndLiteralHighlighter >> selector [
	^ selector
]

{ #category : #accessing }
GtSelectorReferenceAndLiteralHighlighter >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #visiting }
GtSelectorReferenceAndLiteralHighlighter >> visitArrayNode: aNode [
	super visitArrayNode: aNode.
	aNode value = selector
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]

{ #category : #visiting }
GtSelectorReferenceAndLiteralHighlighter >> visitLiteralArrayNode: aNode [
	super visitLiteralArrayNode: aNode.
	aNode value = selector
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]

{ #category : #visiting }
GtSelectorReferenceAndLiteralHighlighter >> visitLiteralNode: aNode [
	super visitLiteralNode: aNode.
	aNode value = selector
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]

{ #category : #visiting }
GtSelectorReferenceAndLiteralHighlighter >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	aMessageNode selector = selector
		ifTrue: [ aMessageNode selectorParts
				with: aMessageNode keywordsPositions
				do: [ :keyword :position | self styleFrom: position to: position + keyword size - 1 with: HighlightAttributes ] ]
]
