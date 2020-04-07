Class {
	#name : #GtBehaviorSuperclassRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'superclass',
		'oldName',
		'newName',
		'owner'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> superclass [
	^ superclass
]

{ #category : #accessing }
GtBehaviorSuperclassRenamed >> superclass: anObject [
	superclass := anObject
]
