Class {
	#name : #GtBehaviorTagRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'tag',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorTagRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorTagRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorTagRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorTagRenamed >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
GtBehaviorTagRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorTagRenamed >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorTagRenamed >> tag [
	^ tag
]

{ #category : #accessing }
GtBehaviorTagRenamed >> tag: anObject [
	tag := anObject
]
