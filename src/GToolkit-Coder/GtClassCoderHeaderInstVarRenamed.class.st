Class {
	#name : #GtClassCoderHeaderInstVarRenamed,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'instanceVariable',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderInstVarRenamed >> instanceVariable [
	^ instanceVariable
]

{ #category : #accessing }
GtClassCoderHeaderInstVarRenamed >> instanceVariable: anObject [
	instanceVariable := anObject
]

{ #category : #accessing }
GtClassCoderHeaderInstVarRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtClassCoderHeaderInstVarRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtClassCoderHeaderInstVarRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtClassCoderHeaderInstVarRenamed >> oldName: anObject [
	oldName := anObject
]
