Class {
	#name : #GtVariableReferenceHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder-AddOns-Reference highlighter'
}

{ #category : #'instance creation' }
GtVariableReferenceHighlighter class >> forVariableName: aString [
	^ self new
		variableName: aString;
		yourself
]

{ #category : #accessing }
GtVariableReferenceHighlighter >> variableName [
	^ variableName
]

{ #category : #accessing }
GtVariableReferenceHighlighter >> variableName: anObject [
	variableName := anObject
]

{ #category : #visiting }
GtVariableReferenceHighlighter >> visitVariableNode: aVariableNode [
	super visitVariableNode: aVariableNode.
	aVariableNode name asString = variableName
		ifTrue: [ self styleFrom: aVariableNode start to: aVariableNode stop with: HighlightAttributes ]
]
