Class {
	#name : #GtClassVariableDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'classVariableName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #accessing }
GtClassVariableDifference >> classVariableName [
	^ classVariableName
]

{ #category : #accessing }
GtClassVariableDifference >> classVariableName: anObject [
	classVariableName := anObject
]
