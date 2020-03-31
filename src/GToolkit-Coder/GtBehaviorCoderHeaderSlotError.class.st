Class {
	#name : #GtBehaviorCoderHeaderSlotError,
	#superclass : #GtBehaviorCoderHeaderError,
	#instVars : [
		'slotName'
	],
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #signalling }
GtBehaviorCoderHeaderSlotError class >> signalFor: aSlotName [
	(self new slotName: aSlotName) signal
]

{ #category : #initialization }
GtBehaviorCoderHeaderSlotError >> initialize [
	super initialize.
	
	slotName := #noName
]

{ #category : #accessing }
GtBehaviorCoderHeaderSlotError >> slotName [
	^ slotName
]

{ #category : #accessing }
GtBehaviorCoderHeaderSlotError >> slotName: anObject [
	slotName := anObject
]
