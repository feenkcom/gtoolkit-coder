Class {
	#name : #GtBehaviorCoderHeaderClassVarRemoved,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariable'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRemoved >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRemoved >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRemoved >> name [
	^ self classVariable name
]
