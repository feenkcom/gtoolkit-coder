Class {
	#name : #GtBehaviorTagAdded,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'tag'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorTagAdded >> name [
	^ self tag name
]

{ #category : #accessing }
GtBehaviorTagAdded >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorTagAdded >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorTagAdded >> tag [
	^ tag
]

{ #category : #accessing }
GtBehaviorTagAdded >> tag: anObject [
	tag := anObject
]
