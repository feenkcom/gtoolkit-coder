Class {
	#name : #GtClassCoderHeaderInstVarRemoved,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'instanceVariable'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderInstVarRemoved >> instanceVariable [
	^ instanceVariable
]

{ #category : #accessing }
GtClassCoderHeaderInstVarRemoved >> instanceVariable: anObject [
	instanceVariable := anObject
]
