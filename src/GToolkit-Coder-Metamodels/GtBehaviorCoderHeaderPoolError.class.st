Class {
	#name : #GtBehaviorCoderHeaderPoolError,
	#superclass : #GtBehaviorCoderHeaderError,
	#instVars : [
		'poolName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Errors'
}

{ #category : #signalling }
GtBehaviorCoderHeaderPoolError class >> signalFor: aPoolName [
	(self new poolName: aPoolName) signal
]

{ #category : #accessing }
GtBehaviorCoderHeaderPoolError >> poolName [
	^ poolName
]

{ #category : #accessing }
GtBehaviorCoderHeaderPoolError >> poolName: anObject [
	poolName := anObject
]
