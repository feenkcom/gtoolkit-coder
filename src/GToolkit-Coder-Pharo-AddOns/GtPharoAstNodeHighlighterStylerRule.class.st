Class {
	#name : #GtPharoAstNodeHighlighterStylerRule,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'styleBlock',
		'nodeClassName',
		'nodeClass'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #accessing }
GtPharoAstNodeHighlighterStylerRule >> nodeClass [
	^ nodeClass ifNil: [ nodeClass := Smalltalk at: nodeClassName ifAbsent: [ self class ] ]
]

{ #category : #accessing }
GtPharoAstNodeHighlighterStylerRule >> nodeClassName [
	^ nodeClassName.
]

{ #category : #accessing }
GtPharoAstNodeHighlighterStylerRule >> nodeClassName: aNodeClassName [
	nodeClassName := aNodeClassName.
]

{ #category : #asserting }
GtPharoAstNodeHighlighterStylerRule >> shouldApplyToNode: aNode [
	^ aNode isKindOf: self nodeClass.
]

{ #category : #accessing }
GtPharoAstNodeHighlighterStylerRule >> styleBlock [
	^ styleBlock.
]

{ #category : #accessing }
GtPharoAstNodeHighlighterStylerRule >> styleBlock: aBlock [
	styleBlock := aBlock.
]

{ #category : #visiting }
GtPharoAstNodeHighlighterStylerRule >> visitNode: aNode [
	super visitNode: aNode.
	(self shouldApplyToNode: aNode)
		ifTrue: [ self styleBlock cull: aNode cull: text ].
]
