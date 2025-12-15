Class {
	#name : #GtFilterSignal,
	#superclass : #ContextStackSignal,
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterSignal class >> gtNormalOperationSignal [
	"Answer a Boolean indicating whether this signal is generated as part of normal operations.
	See {{gtMethod:BeaconSignal class>>gtNormalOperationSignal}} for a description"

	^ true.
]
