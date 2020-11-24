Class {
	#name : #GtMethodCoderSaveDisabled,
	#superclass : #GtMethodCoderSaveAbilityChanged,
	#instVars : [
		'preventors'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method Events'
}

{ #category : #accessing }
GtMethodCoderSaveDisabled >> preventors [
	^ preventors
]

{ #category : #accessing }
GtMethodCoderSaveDisabled >> preventors: anObject [
	preventors := anObject
]

{ #category : #evaluating }
GtMethodCoderSaveDisabled >> value [
	^ false
]
