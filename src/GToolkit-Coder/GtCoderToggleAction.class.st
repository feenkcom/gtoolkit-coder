Class {
	#name : #GtCoderToggleAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'activateBlock',
		'deactivateBlock',
		'toggleModel'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderToggleAction >> activateBlock: aBlock [
	activateBlock := aBlock
]

{ #category : #initialization }
GtCoderToggleAction >> computeActionDefinition [
	activateBlock isClosure
		ifTrue: [ ^ GtCoderActionClosureDefinition new closure: activateBlock ].
	deactivateBlock isClosure
		ifTrue: [ ^ GtCoderActionClosureDefinition new closure: deactivateBlock ].
	^ nil
]

{ #category : #accessing }
GtCoderToggleAction >> deactivateBlock: aBlock [
	deactivateBlock := aBlock
]

{ #category : #accessing }
GtCoderToggleAction >> initialize [
	super initialize.
	activateBlock := deactivateBlock := [ :evt |  ]
]

{ #category : #accessing }
GtCoderToggleAction >> toggleModel [

	^ toggleModel
]

{ #category : #accessing }
GtCoderToggleAction >> toggleModel: aToggleModel [
	toggleModel := aToggleModel
]
