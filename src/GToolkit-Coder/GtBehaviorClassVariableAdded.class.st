Class {
	#name : #GtBehaviorClassVariableAdded,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariable',
		'owner'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorClassVariableAdded >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtBehaviorClassVariableAdded >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtBehaviorClassVariableAdded >> name [
	^ self classVariable name
]

{ #category : #accessing }
GtBehaviorClassVariableAdded >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorClassVariableAdded >> owner: anObject [
	owner := anObject
]
