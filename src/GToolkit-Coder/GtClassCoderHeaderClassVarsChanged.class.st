Class {
	#name : #GtClassCoderHeaderClassVarsChanged,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'classVariables'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderClassVarsChanged >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtClassCoderHeaderClassVarsChanged >> classVariables: anObject [
	classVariables := anObject
]
