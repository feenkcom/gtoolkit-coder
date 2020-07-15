Class {
	#name : #GtBehaviorClassVariableRemoved,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariable',
		'owner'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorClassVariableRemoved >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtBehaviorClassVariableRemoved >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtBehaviorClassVariableRemoved >> name [
	^ self classVariable name
]

{ #category : #accessing }
GtBehaviorClassVariableRemoved >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorClassVariableRemoved >> owner: anObject [
	owner := anObject
]
