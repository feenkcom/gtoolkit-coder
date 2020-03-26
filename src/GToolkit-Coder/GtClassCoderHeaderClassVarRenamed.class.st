Class {
	#name : #GtClassCoderHeaderClassVarRenamed,
	#superclass : #GtClassCoderHeaderChangeEvent,
	#instVars : [
		'classVariable',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderClassVarRenamed >> classVariable [
	^ classVariable
]

{ #category : #accessing }
GtClassCoderHeaderClassVarRenamed >> classVariable: anObject [
	classVariable := anObject
]

{ #category : #accessing }
GtClassCoderHeaderClassVarRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtClassCoderHeaderClassVarRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtClassCoderHeaderClassVarRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtClassCoderHeaderClassVarRenamed >> oldName: anObject [
	oldName := anObject
]
