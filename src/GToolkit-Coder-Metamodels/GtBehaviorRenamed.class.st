Class {
	#name : #GtBehaviorRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'behavior',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorRenamed >> behavior [
	^ behavior
]

{ #category : #accessing }
GtBehaviorRenamed >> behavior: anObject [
	behavior := anObject
]

{ #category : #accessing }
GtBehaviorRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorRenamed >> oldName: anObject [
	oldName := anObject
]
