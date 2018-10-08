Class {
	#name : #GtVariableReferenceHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'variableName'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtVariableReferenceHighlighter class >> forVariableName: aString [
	^ self new
		variableName: aString;
		yourself
]

{ #category : #testing }
GtVariableReferenceHighlighter >> shouldHighlight: aNode [
	^ (aNode isKindOf: RBVariableNode) and: [ aNode name asString = variableName ]
]

{ #category : #accessing }
GtVariableReferenceHighlighter >> variableName [
	^ variableName
]

{ #category : #accessing }
GtVariableReferenceHighlighter >> variableName: anObject [
	variableName := anObject
]
