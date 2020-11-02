Class {
	#name : #GtBehaviorTraitRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'trait',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorTraitRenamed >> newName [
	<return: #Symbol>

	^ newName
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> newName: aSymbol [
	newName := aSymbol
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> oldName [
	<return: #Symbol>

	^ oldName
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> oldName: aSymbol [
	oldName := aSymbol
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> trait [
	<return: #RGTraitDefinition>

	^ trait
]

{ #category : #accessing }
GtBehaviorTraitRenamed >> trait: anRGTraitDefinition [
	trait := anRGTraitDefinition
]
