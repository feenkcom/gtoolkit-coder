Class {
	#name : #GtCoderParseError,
	#superclass : #GtCoderAnnouncement,
	#instVars : [
		'errorMessage',
		'location'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderParseError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
GtCoderParseError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #accessing }
GtCoderParseError >> location [
	^ location
]

{ #category : #accessing }
GtCoderParseError >> location: anObject [
	location := anObject
]
