Class {
	#name : #GtCoderAddOnSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #testing }
GtCoderAddOnSignal class >> gtNormalOperationSignal [
	"Answer a Boolean indicating whether this signal is generated as part of normal operations.
	See {{gtMethod:BeaconSignal class>>gtNormalOperationSignal}} for a description"

	^ true.
]

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
