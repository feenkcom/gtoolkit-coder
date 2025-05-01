Class {
	#name : #GtCoderParseError,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'errorMessage',
		'location',
		'requesterObject',
		'exception'
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
GtCoderParseError >> exception [
	^ exception
]

{ #category : #accessing }
GtCoderParseError >> exception: anException [
	exception := anException
]

{ #category : #testing }
GtCoderParseError >> isUndeclaredError [
	^ exception isKindOf: OCUndeclaredVariableWarning
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
