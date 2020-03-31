Class {
	#name : #GtBehaviorSlotRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'slot',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorSlotRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> slot [
	^ slot
]

{ #category : #accessing }
GtBehaviorSlotRenamed >> slot: anObject [
	slot := anObject
]
