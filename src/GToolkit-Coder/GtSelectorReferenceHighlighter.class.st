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

{ #category : #testing }
GtSelectorReferenceHighlighter >> shouldHighlight: aNode [
	(aNode isKindOf: RBMessageNode)
		ifTrue: [ ^ aNode selector = selector ].
	(aNode isKindOf: RBLiteralValueNode)
		ifTrue: [ ^ aNode value = selector ].
	^ false
]
