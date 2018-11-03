Class {
	#name : #BrRBHighlightingMethodBodyTextStyler,
	#superclass : #BrRBMethodBodyTextStyler,
	#instVars : [
		'highlighter'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'method coder styler' }
BrRBHighlightingMethodBodyTextStyler class >> bodyStylerFor: aMethodCoder [
	<gtMethodCoderBodyStyler: 10>
	^ aMethodCoder bodyStylerForClass: self
]

{ #category : #initialization }
BrRBHighlightingMethodBodyTextStyler class >> initialTextAttributes [
	| attributes |
	attributes := super initialTextAttributes.
	attributes at: #highlight put: {(BlTextUnderlineAttribute new paint: BrGlamorousColors textHighlightColor; width: 3)}.
	^ attributes
	

]

{ #category : #accessing }
BrRBHighlightingMethodBodyTextStyler >> highlighter [
	^ highlighter
]

{ #category : #accessing }
BrRBHighlightingMethodBodyTextStyler >> highlighter: anObject [
	highlighter := anObject
]

{ #category : #'visiting rb nodes' }
BrRBHighlightingMethodBodyTextStyler >> shouldHighlight: aNode [
	^ highlighter notNil and: [ highlighter shouldHighlight: aNode ]
]

{ #category : #'visiting rb nodes' }
BrRBHighlightingMethodBodyTextStyler >> visitLiteralNode: aNode [
	super visitLiteralNode: aNode.
	(self shouldHighlight: aNode)
		ifTrue: [ self addStyle: #highlight from: aNode start to: aNode stop ]
]

{ #category : #'visiting rb nodes' }
BrRBHighlightingMethodBodyTextStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	(self shouldHighlight: aMessageNode)
		ifTrue: [ aMessageNode selectorParts
				with: aMessageNode keywordsPositions
				do: [ :keyword :position | self addStyle: #highlight from: position to: position + keyword size - 1 ] ]
]

{ #category : #'visiting rb nodes' }
BrRBHighlightingMethodBodyTextStyler >> visitPragmaNode: aNode [
	super visitPragmaNode: aNode.
	(self shouldHighlight: aNode)
		ifTrue: [ self addStyle: #highlight from: aNode start to: aNode stop ]
]

{ #category : #'visiting rb nodes' }
BrRBHighlightingMethodBodyTextStyler >> visitVariableNode: aVariableNode [
	super visitVariableNode: aVariableNode.
	(self shouldHighlight: aVariableNode)
		ifTrue: [ self addStyle: #highlight from: aVariableNode start to: aVariableNode stop ]
]
