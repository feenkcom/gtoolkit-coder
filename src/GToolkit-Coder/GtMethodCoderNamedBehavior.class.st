Class {
	#name : #GtMethodCoderNamedBehavior,
	#superclass : #GtMethodCoderBehavior,
	#instVars : [
		'behaviorName',
		'behavior'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #comparing }
GtMethodCoderNamedBehavior >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ behaviorName = anObject behaviorName
]

{ #category : #transformation }
GtMethodCoderNamedBehavior >> affectByClassAdded: aClassAddedAnnouncement [
	^ behaviorName = aClassAddedAnnouncement classAdded name
		ifTrue: [ GtMethodCoderExplicitBehavior new behavior: aClassAddedAnnouncement classAdded ]
		ifFalse: [ self ]
]

{ #category : #transformation }
GtMethodCoderNamedBehavior >> affectByClassRemoved: aClassRemovedAnnouncement [
	^ behavior = aClassRemovedAnnouncement classRemoved
		ifTrue: [ self ]
		ifFalse: [ self class new behaviorName: behaviorName ]
]

{ #category : #transformation }
GtMethodCoderNamedBehavior >> affectByClassRenamed: aClassRenamedAnnouncement [
	^ aClassRenamedAnnouncement oldName = self behaviorName
		ifTrue: [ self class new behaviorName: aClassRenamedAnnouncement newName ]
		ifFalse: [ self ]
]

{ #category : #testing }
GtMethodCoderNamedBehavior >> affectedByClassAdded: aClassAddedAnnouncement [
	^ self behaviorName = aClassAddedAnnouncement classAdded name
]

{ #category : #testing }
GtMethodCoderNamedBehavior >> affectedByClassRemoved: aClassRemovedAnnouncement [
	^ behavior
		ifNil: [ false ]
		ifNotNil: [ behavior = aClassRemovedAnnouncement classRemoved ]
]

{ #category : #testing }
GtMethodCoderNamedBehavior >> affectedByClassRenamed: aClassRenamedAnnouncement [
	^ self behaviorName = aClassRenamedAnnouncement oldName
]

{ #category : #accessing }
GtMethodCoderNamedBehavior >> behavior [
	^ behavior
]

{ #category : #accessing }
GtMethodCoderNamedBehavior >> behaviorName [
	^ behaviorName
]

{ #category : #accessing }
GtMethodCoderNamedBehavior >> behaviorName: aBehaviorName [
	self
		assert: [ behaviorName isNil ]
		description: [ 'I am immutable and can not be changed' ].

	behaviorName := aBehaviorName asSymbol.
	
	behavior := self class environment
		at: behaviorName
		ifAbsent: [ nil ]
]

{ #category : #accessing }
GtMethodCoderNamedBehavior >> behaviorNameDo: aBlock [
	^ aBlock value: self behaviorName
]

{ #category : #testing }
GtMethodCoderNamedBehavior >> exists [
	"Return true if there is a real Behavior in the system corresponding to my definition"
	<return: #Boolean>
	
	^ self class environment includesKey: self behaviorName
]

{ #category : #comparing }
GtMethodCoderNamedBehavior >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ behaviorName hash
]

{ #category : #accessing }
GtMethodCoderNamedBehavior >> realBehaviorDo: aBlock [
	^ self class environment
		at: self behaviorName
		ifPresent: aBlock
		ifAbsent: [ nil ]
]
