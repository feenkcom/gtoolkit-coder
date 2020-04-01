Class {
	#name : #GtBehaviorTagRemoved,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'tag'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorTagRemoved >> name [
	^ self tag name
]

{ #category : #accessing }
GtBehaviorTagRemoved >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorTagRemoved >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorTagRemoved >> tag [
	^ tag
]

{ #category : #accessing }
GtBehaviorTagRemoved >> tag: anObject [
	tag := anObject
]
