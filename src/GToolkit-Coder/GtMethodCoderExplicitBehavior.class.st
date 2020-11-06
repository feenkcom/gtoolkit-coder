Class {
	#name : #GtMethodCoderExplicitBehavior,
	#superclass : #GtMethodCoderBehavior,
	#instVars : [
		'behavior',
		'behaviorName'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #comparing }
GtMethodCoderExplicitBehavior >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ behavior = anObject behavior
]

{ #category : #transformation }
GtMethodCoderExplicitBehavior >> affectByClassAdded: aClassAddedAnnouncement [
	^ (self affectedByClassAdded: aClassAddedAnnouncement)
		ifTrue: [ self class new behavior: aClassAddedAnnouncement classAdded ]
		ifFalse: [ self ]
]

{ #category : #transformation }
GtMethodCoderExplicitBehavior >> affectByClassRemoved: aClassRemovedAnnouncement [
	^ self behavior = aClassRemovedAnnouncement classRemoved
		ifTrue: [ GtMethodCoderNamedBehavior new behaviorName: behaviorName ]
		ifFalse: [ self ]
]

{ #category : #transformation }
GtMethodCoderExplicitBehavior >> affectByClassRenamed: aClassRenamedAnnouncement [
	^ self behavior = aClassRenamedAnnouncement classRenamed
		ifTrue: [ self class new behavior: aClassRenamedAnnouncement classRenamed ]
		ifFalse: [ self ]
]

{ #category : #testing }
GtMethodCoderExplicitBehavior >> affectedByClassAdded: aClassRemovedAnnouncement [
	^ self behavior = aClassRemovedAnnouncement classAdded
		or: [ self behaviorName = aClassRemovedAnnouncement classAdded name ]
]

{ #category : #testing }
GtMethodCoderExplicitBehavior >> affectedByClassRemoved: aClassRemovedAnnouncement [
	^ self behavior = aClassRemovedAnnouncement classRemoved
]

{ #category : #testing }
GtMethodCoderExplicitBehavior >> affectedByClassRenamed: aClassRenamedAnnouncement [
	^ self behavior = aClassRenamedAnnouncement classRenamed
]

{ #category : #accessing }
GtMethodCoderExplicitBehavior >> behavior [
	^ behavior
]

{ #category : #accessing }
GtMethodCoderExplicitBehavior >> behavior: aBehavior [
	self
		assert: [ behavior isNil ]
		description: [ 'I am immutable and can not be changed' ].

	behavior := aBehavior.
	behaviorName := aBehavior name
]

{ #category : #accessing }
GtMethodCoderExplicitBehavior >> behaviorName [
	^ behaviorName
]

{ #category : #accessing }
GtMethodCoderExplicitBehavior >> behaviorNameDo: aBlock [
	^ self exists
		ifTrue: [ aBlock value: behavior name ]
		ifFalse: [
			behaviorName
				ifNotNil: [ :aName | aBlock value: aName ]
				ifNil: [ nil ] ]
]

{ #category : #testing }
GtMethodCoderExplicitBehavior >> exists [
	"Return true if there is a real Behavior in the system corresponding to my definition"
	<return: #Boolean>
	
	^ self behavior isObsolete not
]

{ #category : #comparing }
GtMethodCoderExplicitBehavior >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ behavior hash
]

{ #category : #accessing }
GtMethodCoderExplicitBehavior >> realBehaviorDo: aBlock [
	^ self exists
		ifTrue: [ aBlock value: self behavior ]
		ifFalse: [ nil ]
]
