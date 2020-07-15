Class {
	#name : #GtBehaviorClassVariableRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariable',
		'oldName',
		'newName',
		'owner'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorClassVariableRenamed >> owner: anObject [
	owner := anObject
]
