"
I contain properties for how a coder should send notifications when code changes.

Currently I indicate if code should be changed syncronously or asyncronously.


"
Class {
	#name : #GtCoderUpdateStrategy,
	#superclass : #Object,
	#instVars : [
		'announcementSource',
		'isSynchronous'
	],
	#category : 'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderUpdateStrategy >> isSynchronous [
	^ isSynchronous ifNil: [ false ]
]

{ #category : #accessing }
GtCoderUpdateStrategy >> isSynchronous: anObject [
	isSynchronous := anObject
]

{ #category : #accessing }
GtCoderUpdateStrategy >> makeAsynchronous [
	isSynchronous := false
]

{ #category : #accessing }
GtCoderUpdateStrategy >> makeSynchronous [
	isSynchronous := true
]

{ #category : #accessing }
GtCoderUpdateStrategy >> source [
	^ announcementSource
]

{ #category : #accessing }
GtCoderUpdateStrategy >> source: anObject [
	announcementSource := anObject
]
