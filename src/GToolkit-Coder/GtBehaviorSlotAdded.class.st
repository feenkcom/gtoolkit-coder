Class {
	#name : #GtBehaviorSlotAdded,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'slot'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorSlotAdded >> name [
	^ self slot name
]

{ #category : #accessing }
GtBehaviorSlotAdded >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorSlotAdded >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorSlotAdded >> slot [
	^ slot
]

{ #category : #accessing }
GtBehaviorSlotAdded >> slot: anObject [
	slot := anObject
]
