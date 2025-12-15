Class {
	#name : #GtSourceCoderProcessInDebuggerSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'process',
		'space'
	],
	#category : 'GToolkit-Coder-UI-Signals'
}

{ #category : #testing }
GtSourceCoderProcessInDebuggerSignal class >> gtNormalOperationSignal [
	"Answer a Boolean indicating whether this signal is generated as part of normal operations.
	See {{gtMethod:BeaconSignal class>>gtNormalOperationSignal}} for a description"

	^ true.
]

{ #category : #printing }
GtSourceCoderProcessInDebuggerSignal >> printOneLineContentsOn: aStream [
	aStream print: space
]

{ #category : #accessing }
GtSourceCoderProcessInDebuggerSignal >> process [
	^ process
]

{ #category : #accessing }
GtSourceCoderProcessInDebuggerSignal >> process: anObject [
	process := anObject
]

{ #category : #accessing }
GtSourceCoderProcessInDebuggerSignal >> space [
	^ space
]

{ #category : #accessing }
GtSourceCoderProcessInDebuggerSignal >> space: anObject [
	space := anObject
]
