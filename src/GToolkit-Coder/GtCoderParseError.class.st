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
	^ self
		forPharo12AndNewer: [ (errorMessage beginsWith: 'Undeclared variable')
				or: [ errorMessage beginsWith: 'Undeclared temp' ] ]
		forPharo11: [ exception isKindOf: OCUndeclaredVariableWarning ]
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
GtCoderParseError >> node [
	"The node in the exception is an RB node (Pharo 11)"

	^ (self exception notNil and: [ self exception respondsTo: #node ])
		ifTrue: [ self exception node ]
		ifFalse: [ coder rbAST ifNotNil: [ :node | node nodeForOffset: location ] ]
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
