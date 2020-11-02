Class {
	#name : #GtBehaviorSlotRemoved,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'slot'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorSlotRemoved >> name [
	^ self slot name
]

{ #category : #accessing }
GtBehaviorSlotRemoved >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorSlotRemoved >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorSlotRemoved >> slot [
	^ slot
]

{ #category : #accessing }
GtBehaviorSlotRemoved >> slot: anObject [
	slot := anObject
]
