Class {
	#name : #GtCoderParseError,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'errorMessage',
		'location',
		'requesterObject'
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

{ #category : #accessing }
GtCoderParseError >> requesterObject [
	<return: #TGtCoderRequesterObject>
	^ requesterObject
]

{ #category : #accessing }
GtCoderParseError >> requesterObject: anObject [
	requesterObject := anObject asCoderRequesterObject
]
