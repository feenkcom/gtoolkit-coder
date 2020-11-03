Class {
	#name : #GtBehaviorPoolAdded,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'pool'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorPoolAdded >> name [
	^ self pool name
]

{ #category : #accessing }
GtBehaviorPoolAdded >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorPoolAdded >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorPoolAdded >> pool [
	^ pool
]

{ #category : #accessing }
GtBehaviorPoolAdded >> pool: anObject [
	pool := anObject
]
