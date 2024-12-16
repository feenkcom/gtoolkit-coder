Class {
	#name : #GtCoderAddOnCreatedSignal,
	#superclass : #GtCoderAddOnsComputationSignal,
	#instVars : [
		'addOnClass',
		'addOnSelector'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderAddOnCreatedSignal >> addOnClass [
	^ addOnClass
]

{ #category : #accessing }
GtCoderAddOnCreatedSignal >> addOnClass: anObject [
	addOnClass := anObject
]

{ #category : #accessing }
GtCoderAddOnCreatedSignal >> addOnSelector [
	^ addOnSelector
]

{ #category : #accessing }
GtCoderAddOnCreatedSignal >> addOnSelector: anObject [
	addOnSelector := anObject
]
