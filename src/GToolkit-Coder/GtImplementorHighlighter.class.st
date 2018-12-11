Class {
	#name : #GtImplementorHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtImplementorHighlighter class >> forSelector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #accessing }
GtImplementorHighlighter >> selector [
	^ selector
]

{ #category : #accessing }
GtImplementorHighlighter >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #visiting }
GtImplementorHighlighter >> visitMethodNode: aMethodNode [
	super visitMethodNode: aMethodNode.
	aMethodNode selector = selector
		ifTrue: [ aMethodNode keywordsIntervals do: [ :each | self styleFrom: each first to: each last with: HighlightAttributes ] ]
]
