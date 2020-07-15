Class {
	#name : #GtBehaviorTraitAdded,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'trait'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorTraitAdded >> name [
	^ self trait name
]

{ #category : #accessing }
GtBehaviorTraitAdded >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorTraitAdded >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorTraitAdded >> trait [
	<return: #RGTraitDefinition>

	^ trait
]

{ #category : #accessing }
GtBehaviorTraitAdded >> trait: anRGTraitDefinition [
	trait := anRGTraitDefinition
]
