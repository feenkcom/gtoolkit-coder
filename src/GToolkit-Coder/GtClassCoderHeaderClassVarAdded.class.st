Class {
	#name : #GtClassCoderHeaderClassVarAdded,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'classVariable'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderClassVarAdded >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtClassCoderHeaderClassVarAdded >> classVariable: anObject [
	classVariable := anObject
]
