Class {
	#name : #GtClassCoderHeaderInstVarsChanged,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'instanceVariables'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderInstVarsChanged >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
GtClassCoderHeaderInstVarsChanged >> instanceVariables: anObject [
	instanceVariables := anObject
]
