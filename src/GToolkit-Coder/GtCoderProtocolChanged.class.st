Class {
	#name : #GtCoderProtocolChanged,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'newProtocol'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderProtocolChanged >> newProtocol [
	^ newProtocol
]

{ #category : #accessing }
GtCoderProtocolChanged >> newProtocol: anObject [
	newProtocol := anObject
]
