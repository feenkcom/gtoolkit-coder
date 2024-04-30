Class {
	#name : #GtCoderShowDebuggerRequest,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'debugSession',
		'exception',
		'sourceString',
		'sourceInterval',
		'isDelivered'
	],
	#category : #'GToolkit-Coder-Event'
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

{ #category : #initialization }
GtCoderShowDebuggerRequest >> initialize [
	super initialize.
	isDelivered := false
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> isDelivered [
	"Return true if the request was handled (and debugger displayed)."

	<return: #Boolean>
	^ isDelivered ifNil: [ false ]
]

{ #category : #accessing }
GtCoderShowDebuggerRequest >> isDelivered: aBoolean [
	isDelivered := aBoolean
]

{ #category : #initialization }
GtCoderShowDebuggerRequest >> prepareForDelivery [
	super prepareForDelivery.
	isDelivered := true
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
