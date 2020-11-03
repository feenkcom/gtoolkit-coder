Class {
	#name : #GtClassVariableDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'classVariableName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #accessing }
GtClassVariableDifference >> classVariableName [
	^ classVariableName
]

{ #category : #accessing }
GtClassVariableDifference >> classVariableName: anObject [
	classVariableName := anObject
]
