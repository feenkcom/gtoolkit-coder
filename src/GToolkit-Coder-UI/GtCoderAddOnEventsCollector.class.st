Class {
	#name : #GtCoderAddOnEventsCollector,
	#superclass : #GtBeaconEventsCollector,
	#category : 'GToolkit-Coder-UI-Signals'
}

{ #category : #'as yet unclassified' }
GtCoderAddOnEventsCollector >> createDefaultEventsGrouper [
	^ GtCoderAddOnEventsGrouper new
]

{ #category : #'as yet unclassified' }
GtCoderAddOnEventsCollector >> relevantSignalType [
	^ GtCoderAddOnsComputationSignal
]
