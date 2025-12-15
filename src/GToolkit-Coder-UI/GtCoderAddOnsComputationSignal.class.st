Class {
	#name : #GtCoderAddOnsComputationSignal,
	#superclass : #GtCoderAddOnSignal,
	#category : 'GToolkit-Coder-UI-Signals'
}

{ #category : #'as yet unclassified' }
GtCoderAddOnsComputationSignal class >> eventType [
	^ GtCoderAddOnsComputedEvent
]

{ #category : #'as yet unclassified' }
GtCoderAddOnsComputationSignal >> isEndSignalType [
	^ false
]

{ #category : #'as yet unclassified' }
GtCoderAddOnsComputationSignal >> isStartSignalType [
	^ false
]
