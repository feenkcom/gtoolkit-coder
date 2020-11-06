Class {
	#name : #GtMethodCoderBehavior,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtMethodCoderBehavior class >> explicit: aBehavior [
	^ GtMethodCoderExplicitBehavior new behavior: aBehavior
]

{ #category : #'instance creation' }
GtMethodCoderBehavior class >> named: aBehaviorName [
	^ GtMethodCoderNamedBehavior new behaviorName: aBehaviorName
]

{ #category : #'instance creation' }
GtMethodCoderBehavior class >> unspecified [
	^ GtMethodCoderUnspecifiedBehavior new
]

{ #category : #transformation }
GtMethodCoderBehavior >> affectByClassAdded: aClassAddedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #transformation }
GtMethodCoderBehavior >> affectByClassRemoved: aClassRemovedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #transformation }
GtMethodCoderBehavior >> affectByClassRenamed: aClassRenamedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #testing }
GtMethodCoderBehavior >> affectedByClassAdded: aClassAddedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #testing }
GtMethodCoderBehavior >> affectedByClassRemoved: aClassRemovedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #testing }
GtMethodCoderBehavior >> affectedByClassRenamed: aClassRenamedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtMethodCoderBehavior >> behaviorNameDo: aBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtMethodCoderBehavior >> behaviorNameDo: aBlock ifAbsent: anAbsentBlock [
	self behaviorNameDo: [ :aBehavior | ^ aBlock value: aBehavior ].
	^ anAbsentBlock value
]

{ #category : #testing }
GtMethodCoderBehavior >> exists [
	"Return true if there is a real Behavior in the system corresponding to my definition"
	<return: #Boolean>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
GtMethodCoderBehavior >> realBehaviorDo: aBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtMethodCoderBehavior >> realBehaviorDo: aBlock ifAbsent: anAbsentBlock [
	self realBehaviorDo: [ :aBehavior | ^ aBlock value: aBehavior ].
	^ anAbsentBlock value
]
