Class {
	#name : #GtCodeDiffRBTextStyler,
	#superclass : #BrRBTextStyler,
	#category : 'GToolkit-Coder-UI-Diff'
}

{ #category : #private }
GtCodeDiffRBTextStyler >> resolveStyleFor: aVariableNode [
	| value |
	value := super resolveStyleFor: aVariableNode.
	^ value = #invalid
		ifTrue: [ #default ]
		ifFalse: [ value ]
]

{ #category : #private }
GtCodeDiffRBTextStyler >> resolveStyleOpenBracket: aVariableNode [
	| value |
	value := super resolveStyleOpenBracket: aVariableNode.
	^ value = #invalid
		ifTrue: [ #default ]
		ifFalse: [ value ]
]
