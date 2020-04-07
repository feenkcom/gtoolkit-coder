Class {
	#name : #GtVariableDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'originalName',
		'name'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtVariableDefinition class >> fromClassVariable: aClassVariable [
	^ self new fromClassVariable: aClassVariable
]

{ #category : #'instance creation' }
GtVariableDefinition class >> named: aName [
	^ self new named: aName
]

{ #category : #converting }
GtVariableDefinition >> asDefinitionString [
	^ self name
]

{ #category : #initialization }
GtVariableDefinition >> fromClassVariable: aClassVariable [
	name := aClassVariable name asSymbol.
	originalName := name
]

{ #category : #accessing }
GtVariableDefinition >> name [
	^ name
]

{ #category : #accessing }
GtVariableDefinition >> name: anObject [
	name := anObject
]

{ #category : #initialization }
GtVariableDefinition >> named: aName [
	name := aName.
	originalName := aName
]

{ #category : #accessing }
GtVariableDefinition >> originalName [
	^ originalName
]

{ #category : #accessing }
GtVariableDefinition >> originalName: anObject [
	originalName := anObject
]

{ #category : #printing }
GtVariableDefinition >> printOn: aStream [
	aStream print: self name
]
