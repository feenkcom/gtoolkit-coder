Class {
	#name : #GtBehaviorPoolRemoved,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'pool'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorPoolRemoved >> name [
	^ self pool name
]

{ #category : #accessing }
GtBehaviorPoolRemoved >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorPoolRemoved >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorPoolRemoved >> pool [
	^ pool
]

{ #category : #accessing }
GtBehaviorPoolRemoved >> pool: anObject [
	pool := anObject
]
