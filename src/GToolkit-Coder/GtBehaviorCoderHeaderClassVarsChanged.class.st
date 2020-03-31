Class {
	#name : #GtBehaviorCoderHeaderClassVarsChanged,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariables'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarsChanged >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarsChanged >> classVariables: anObject [
	classVariables := anObject
]
