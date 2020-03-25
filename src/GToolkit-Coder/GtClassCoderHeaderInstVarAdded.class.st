Class {
	#name : #GtClassCoderHeaderInstVarAdded,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'instanceVariable'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderInstVarAdded >> instanceVariable [
	^ instanceVariable
]

{ #category : #accessing }
GtClassCoderHeaderInstVarAdded >> instanceVariable: anObject [
	instanceVariable := anObject
]
