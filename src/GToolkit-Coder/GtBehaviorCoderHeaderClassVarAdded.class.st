Class {
	#name : #GtBehaviorCoderHeaderClassVarAdded,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariable'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarAdded >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarAdded >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarAdded >> name [
	^ self classVariable name
]
