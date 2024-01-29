Class {
	#name : #GtCoderObjectSpawnRequest,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'object',
		'spawnDestination',
		'requesterObject'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderObjectSpawnRequest >> object [
	^ object
]

{ #category : #accessing }
GtCoderObjectSpawnRequest >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtCoderObjectSpawnRequest >> requesterObject [
	<return: #TGtCoderRequesterObject>
	^ requesterObject ifNil: [ GtNoCoderRequester uniqueInstance ]
]

{ #category : #accessing }
GtCoderObjectSpawnRequest >> requesterObject: anObject [
	requesterObject := anObject asCoderRequesterObject
]

{ #category : #accessing }
GtCoderObjectSpawnRequest >> spawnDestination [
	^ spawnDestination
]

{ #category : #accessing }
GtCoderObjectSpawnRequest >> spawnDestination: anObject [
	spawnDestination := anObject
]
