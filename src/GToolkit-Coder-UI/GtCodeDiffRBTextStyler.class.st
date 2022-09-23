Class {
	#name : #GtCodeDiffRBTextStyler,
	#superclass : #BrRBTextStyler,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #private }
GtCodeDiffRBTextStyler >> resolveStyleFor: aVariableNode [
	| value |
	value := super resolveStyleFor: aVariableNode.
	^ value = #invalid
		ifTrue: [ #default ]
		ifFalse: [ value ]
]
