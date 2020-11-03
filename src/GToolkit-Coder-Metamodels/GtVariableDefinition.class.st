Class {
	#name : #GtVariableDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'originalName',
		'name',
		'value'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Definitions'
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
	^ self name printString
]

{ #category : #initialization }
GtVariableDefinition >> fromClassVariable: aClassVariable [
	name := aClassVariable name asSymbol.
	originalName := name.
	value := aClassVariable value
]

{ #category : #testing }
GtVariableDefinition >> isValidName [
	^ RBScanner isVariable: self name
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

{ #category : #accessing }
GtVariableDefinition >> value [
	^ value
]
