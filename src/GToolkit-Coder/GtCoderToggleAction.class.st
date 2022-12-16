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
