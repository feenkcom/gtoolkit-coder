Class {
	#name : #GtCommentsReferenceHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'commentsFilter'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtCommentsReferenceHighlighter >> commentsFilter: aCommentsFilter [
	commentsFilter := aCommentsFilter
]

{ #category : #accessing }
GtCommentsReferenceHighlighter >> visitMethodNode: aNode [
	commentsFilter
		matchingIntervalsInAST: aNode
		do:
			[ :each | self styleFrom: each first to: each last with: HighlightAttributes ]
]
