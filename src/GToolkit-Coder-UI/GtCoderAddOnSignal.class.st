Class {
	#name : #GtCoderAddOnSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderAddOnSignal >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderAddOnSignal >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #'as yet unclassified' }
GtCoderAddOnSignal >> signalTypeLabel [
	^ self class name asString
]
