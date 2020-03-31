Class {
	#name : #GtBehaviorTraitRemoved,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'trait'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorTraitRemoved >> name [
	^ self trait name
]

{ #category : #accessing }
GtBehaviorTraitRemoved >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorTraitRemoved >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorTraitRemoved >> trait [
	<return: #RGTraitDefinition>

	^ trait
]

{ #category : #accessing }
GtBehaviorTraitRemoved >> trait: anRGTraitDefinition [
	trait := anRGTraitDefinition
]
