Class {
	#name : #GtCoderShowDebuggerRequest,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'debugSession',
		'exception',
		'sourceString',
		'sourceInterval'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderShowDebuggerRequest >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> exception [
	^ exception
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> sourceInterval [
	^ sourceInterval
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> sourceString: anObject [
	sourceString := anObject
]
