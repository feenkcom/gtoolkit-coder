Class {
	#name : #GtPharoAstPatternHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'ast'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoAstPatternHighlighter class >> ast: aRBProgramNode [
	^ self new
		ast: aRBProgramNode;
		yourself
]

{ #category : #accessing }
GtPharoAstPatternHighlighter >> ast [
	<return: #GtPharoProgramNode>

	^ ast
]

{ #category : #accessing }
GtPharoAstPatternHighlighter >> ast: aGtPharoProgramNode [
	ast := aGtPharoProgramNode
]

{ #category : #visiting }
GtPharoAstPatternHighlighter >> visitSmaCCParseNode: aNode [	
	(ast match: aNode inContext: Dictionary new)
		ifTrue: [ stream nextPut: (aNode startPosition to: aNode stopPosition) ]
		ifFalse: [ super visitSmaCCParseNode: aNode ]
]
