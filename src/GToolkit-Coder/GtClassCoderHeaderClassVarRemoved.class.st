Class {
	#name : #GtClassCoderHeaderClassVarRemoved,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'classVariable'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderClassVarRemoved >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtClassCoderHeaderClassVarRemoved >> classVariable: anObject [
	classVariable := anObject
]
