Class {
	#name : #GtProcessCoder,
	#superclass : #GtMethodsCoder,
	#instVars : [
		'session',
		'lists'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtProcessCoder class >> forProcess: aProcess [
	^ self new
		forProcess: aProcess;
		yourself
]

{ #category : #elements }
GtProcessCoder >> asElement [
	| element |
	element := super asElement.
	lists add: element.
	^ element
]

{ #category : #updating }
GtProcessCoder >> drillDown: anAnnouncement [
	lists
		do: [ :list | 
			list
				fireEvent:
					(GtPhlowObjectToSpawn new
						object: anAnnouncement value;
						sourceElement: list) ]
]

{ #category : #'initialize-release' }
GtProcessCoder >> forProcess: aProcess [
	session := DebugSession named: 'Debug ' , aProcess name on: aProcess startedAt: aProcess suspendedContext.
	self updateCoders
]

{ #category : #'initialize-release' }
GtProcessCoder >> initialize [
	super initialize.
	methodCoders := OrderedCollection new.
	lists := OrderedCollection new
]

{ #category : #testing }
GtProcessCoder >> isSuspended [
	^ session process notNil and: [ session process isSuspended and: [ session process isTerminating not and: [ session process isTerminated not ] ] ]
]

{ #category : #updating }
GtProcessCoder >> updateCoders [
	| context firstContext coder newCoders |
	self isSuspended
		ifTrue: [ methodCoders := methodCoders reject: [ :each | each isDead ].
			firstContext := methodCoders isEmpty
				ifTrue: [ nil ]
				ifFalse: [ methodCoders first context ].
			context := session process suspendedContext.
			newCoders := OrderedCollection new.
			[ context notNil and: [ context ~~ firstContext ] ]
				whileTrue: [ coder := GtMethodContextCoder forContext: context session: session.
					coder when: GtCoderRefreshStackAnnouncement do: [ :event | self updateCoders ].
					newCoders add: coder.
					context := context sender ].
			methodCoders addAllFirst: newCoders.
			methodCoders notEmpty
				ifTrue: [ methodCoders first expanded: true ] ]
		ifFalse: [ methodCoders := OrderedCollection new ].
	self updateLists
]

{ #category : #elements }
GtProcessCoder >> updateLists [
	lists do: [ :each | each display: methodCoders ]
]
