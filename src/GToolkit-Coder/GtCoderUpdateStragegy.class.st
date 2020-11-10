"
I contain properties for how a coder should send notifications when code changes.

Currently I indicate if code should be changed syncronously or asyncronously.
"
Class {
	#name : #GtCoderUpdateStragegy,
	#superclass : #Object,
	#instVars : [
		'isSynchronous'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderUpdateStragegy >> isSynchronous [
	^ isSynchronous ifNil: [ false ]
]

{ #category : #accessing }
GtCoderUpdateStragegy >> makeAsynchronous [
	isSynchronous := false
]

{ #category : #accessing }
GtCoderUpdateStragegy >> makeSynchronous [
	isSynchronous := true
]
