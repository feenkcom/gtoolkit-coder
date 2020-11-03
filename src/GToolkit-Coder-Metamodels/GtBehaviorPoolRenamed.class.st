Class {
	#name : #GtBehaviorPoolRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'pool',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorPoolRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> pool [
	^ pool
]

{ #category : #accessing }
GtBehaviorPoolRenamed >> pool: anObject [
	pool := anObject
]
