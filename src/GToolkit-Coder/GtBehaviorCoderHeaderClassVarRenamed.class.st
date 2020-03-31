Class {
	#name : #GtBehaviorCoderHeaderClassVarRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'classVariable',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRenamed >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRenamed >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorCoderHeaderClassVarRenamed >> oldName: anObject [
	oldName := anObject
]
