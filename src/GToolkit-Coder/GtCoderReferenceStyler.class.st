Class {
	#name : #GtCoderReferenceStyler,
	#superclass : #GtCoderBodyStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'highlighter'
	],
	#classVars : [
		'HighlightAttributes'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'class initialization' }
GtCoderReferenceStyler class >> initialize [
	HighlightAttributes := {(BlTextUnderlineAttribute new
		paint: BrGlamorousColors textHighlightColor;
		width: 3)}
]

{ #category : #accessing }
GtCoderReferenceStyler >> highlighter [
	^ highlighter
]

{ #category : #accessing }
GtCoderReferenceStyler >> highlighter: anObject [
	highlighter := anObject
]

{ #category : #testing }
GtCoderReferenceStyler >> shouldHighlight: aNode [
	^ highlighter notNil and: [ highlighter shouldHighlight: aNode ]
]

{ #category : #visiting }
GtCoderReferenceStyler >> visitLiteralNode: aNode [
	super visitLiteralNode: aNode.
	(self shouldHighlight: aNode)
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]

{ #category : #visiting }
GtCoderReferenceStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	(self shouldHighlight: aMessageNode)
		ifTrue: [ aMessageNode selectorParts
				with: aMessageNode keywordsPositions
				do: [ :keyword :position | self styleFrom: position to: position + keyword size - 1 with: HighlightAttributes ] ]
]

{ #category : #visiting }
GtCoderReferenceStyler >> visitPragmaNode: aNode [
	super visitPragmaNode: aNode.
	(self shouldHighlight: aNode)
		ifTrue: [ self styleFrom: aNode start to: aNode stop with: HighlightAttributes ]
]

{ #category : #visiting }
GtCoderReferenceStyler >> visitVariableNode: aVariableNode [
	super visitVariableNode: aVariableNode.
	(self shouldHighlight: aVariableNode)
		ifTrue: [ self styleFrom: aVariableNode start to: aVariableNode stop with: HighlightAttributes ]
]
