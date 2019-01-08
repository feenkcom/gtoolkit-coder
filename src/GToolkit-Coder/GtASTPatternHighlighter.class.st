Class {
	#name : #GtASTPatternHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'ast'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtASTPatternHighlighter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #accessing }
GtASTPatternHighlighter >> ast [
	^ ast
]

{ #category : #accessing }
GtASTPatternHighlighter >> ast: aRBProgramNode [
	ast := aRBProgramNode
]

{ #category : #visiting }
GtASTPatternHighlighter >> visitNode: aNode [
	(ast match: aNode inContext: Dictionary new)
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
		ifFalse: [ super visitNode: aNode ]
]
