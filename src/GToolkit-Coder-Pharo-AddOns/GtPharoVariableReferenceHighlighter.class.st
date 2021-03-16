Class {
	#name : #GtPharoVariableReferenceHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoVariableReferenceHighlighter class >> forVariableName: aString [
	^ self new
		variableName: aString;
		yourself
]

{ #category : #accessing }
GtPharoVariableReferenceHighlighter >> variableName [
	^ variableName
]

{ #category : #accessing }
GtPharoVariableReferenceHighlighter >> variableName: anObject [
	variableName := anObject
]

{ #category : #visiting }
GtPharoVariableReferenceHighlighter >> visitVariable: aVariableNode [
	super visitVariable: aVariableNode.

	aVariableNode variableName = variableName
		ifTrue: [
			stream nextPut: (aVariableNode name startPosition to: aVariableNode name stopPosition) ]
]
