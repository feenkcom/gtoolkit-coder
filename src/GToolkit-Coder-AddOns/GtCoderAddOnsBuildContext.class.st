"
My main purpose is to pass information while building coder addOns without having to add more method parameters.
"
Class {
	#name : #GtCoderAddOnsBuildContext,
	#superclass : #Object,
	#instVars : [
		'documentId'
	],
	#category : #'GToolkit-Coder-AddOns-Support'
}

{ #category : #accessing }
GtCoderAddOnsBuildContext >> documentId [
	^ documentId
]

{ #category : #accessing }
GtCoderAddOnsBuildContext >> documentId: anObject [
	documentId := anObject
]
