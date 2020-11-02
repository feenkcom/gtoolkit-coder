Class {
	#name : #GtBehaviorCoderHeaderTraitError,
	#superclass : #GtBehaviorCoderHeaderError,
	#instVars : [
		'traitName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #signalling }
GtBehaviorCoderHeaderTraitError class >> signalFor: aTraitName [
	(self new traitName: aTraitName) signal
]

{ #category : #initialization }
GtBehaviorCoderHeaderTraitError >> initialize [
	super initialize.
	
	traitName := #NoName
]

{ #category : #accessing }
GtBehaviorCoderHeaderTraitError >> traitName [
	^ traitName
]

{ #category : #accessing }
GtBehaviorCoderHeaderTraitError >> traitName: anObject [
	traitName := anObject
]
