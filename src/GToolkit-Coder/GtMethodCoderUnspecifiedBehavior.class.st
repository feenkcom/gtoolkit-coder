Class {
	#name : #GtMethodCoderUnspecifiedBehavior,
	#superclass : #GtMethodCoderBehavior,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #comparing }
GtMethodCoderUnspecifiedBehavior >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : #transformation }
GtMethodCoderUnspecifiedBehavior >> affectByClassAdded: aClassAddedAnnouncement [
	^ self
]

{ #category : #transformation }
GtMethodCoderUnspecifiedBehavior >> affectByClassRemoved: aClassRemovedAnnouncement [
	^ self
]

{ #category : #transformation }
GtMethodCoderUnspecifiedBehavior >> affectByClassRenamed: aClassRenamedAnnouncement [
	^ self
]

{ #category : #testing }
GtMethodCoderUnspecifiedBehavior >> affectedByClassAdded: aClassAddedAnnouncement [
	^ false
]

{ #category : #testing }
GtMethodCoderUnspecifiedBehavior >> affectedByClassRemoved: aClassRemovedAnnouncement [
	^ false
]

{ #category : #testing }
GtMethodCoderUnspecifiedBehavior >> affectedByClassRenamed: aClassRenamedAnnouncement [
	^ false
]

{ #category : #accessing }
GtMethodCoderUnspecifiedBehavior >> behaviorNameDo: aBlock [
	^ nil
]

{ #category : #testing }
GtMethodCoderUnspecifiedBehavior >> exists [
	"Return true if there is a real Behavior in the system corresponding to my definition"
	<return: #Boolean>
	
	^ false
]

{ #category : #comparing }
GtMethodCoderUnspecifiedBehavior >> hash [
	^ self class hash
]

{ #category : #accessing }
GtMethodCoderUnspecifiedBehavior >> realBehaviorDo: aBlock [
	^ nil
]
