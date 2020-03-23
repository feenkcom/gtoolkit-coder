Class {
	#name : #GtASTNodeHighlighterStylerRule,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'styleBlock',
		'nodeClassName',
		'nodeClass'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtASTNodeHighlighterStylerRule >> nodeClass [
	^ nodeClass ifNil: [ nodeClass := Smalltalk at: nodeClassName ifAbsent: [ self class ] ]
]

{ #category : #accessing }
GtASTNodeHighlighterStylerRule >> nodeClassName [
	^ nodeClassName.
]

{ #category : #accessing }
GtASTNodeHighlighterStylerRule >> nodeClassName: aNodeClassName [
	nodeClassName := aNodeClassName.
]

{ #category : #asserting }
GtASTNodeHighlighterStylerRule >> shouldApplyToNode: aNode [
	^ aNode isKindOf: self nodeClass.
]

{ #category : #accessing }
GtASTNodeHighlighterStylerRule >> styleBlock [
	^ styleBlock.
]

{ #category : #accessing }
GtASTNodeHighlighterStylerRule >> styleBlock: aBlock [
	styleBlock := aBlock.
]

{ #category : #visiting }
GtASTNodeHighlighterStylerRule >> visitNode: aNode [
	super visitNode: aNode.
	(self shouldApplyToNode: aNode)
		ifTrue: [ self styleBlock cull: aNode cull: text ].
]
