"
I add a yellow circle adornment to variables in a text. The variables are argument node, temporary nodes, self nodes, super node and global nodes.
"
Class {
	#name : #GtVariableExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'variablesDictionary'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #adding }
GtVariableExplanationLinkStyler >> addVariableName: aVariableName [
	self addVariableName: aVariableName withIdentifier: aVariableName.
]

{ #category : #adding }
GtVariableExplanationLinkStyler >> addVariableName: aVariableName withIdentifier: anIdentifier [
	variablesDictionary at: aVariableName put: anIdentifier.
]

{ #category : #adding }
GtVariableExplanationLinkStyler >> addVariables: aCollection [
	aCollection do: [ :variable | self addVariableName: variable ].
]

{ #category : #initialization }
GtVariableExplanationLinkStyler >> initialize [
	super initialize.
	variablesDictionary := IdentityDictionary new.
]

{ #category : #accessing }
GtVariableExplanationLinkStyler >> variablesAssociations [
	^ variablesDictionary associations.
]

{ #category : #visiting }
GtVariableExplanationLinkStyler >> visitVariableNode: aVariableNode [
	self variablesAssociations do: [:association |
		super visitVariableNode: aVariableNode.
		(aVariableNode name asString = association key) ifTrue:
			[ self styleFrom: (aVariableNode start - 1) to: (aVariableNode start - 1) 
				with: { GtYellowCircleExplanationTextAdornment forIdentifier: (association value) } ]].
]
