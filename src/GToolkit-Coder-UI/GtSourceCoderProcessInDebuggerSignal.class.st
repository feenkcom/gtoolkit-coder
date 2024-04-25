Class {
	#name : #GtSourceCoderProcessInDebuggerSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'process',
		'space'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

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
