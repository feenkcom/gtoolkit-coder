Class {
	#name : #GtCoderToolSpawnRequest,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'tool',
		'spawnDestination',
		'requesterObject'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderToolSpawnRequest >> spawnDestination [
	^ spawnDestination
]

{ #category : #accessing }
GtCoderToolSpawnRequest >> spawnDestination: anObject [
	spawnDestination := anObject
]

{ #category : #accessing }
GtCoderToolSpawnRequest >> tool [
	^ tool
]

{ #category : #accessing }
GtCoderToolSpawnRequest >> tool: anObject [
	tool := anObject
]
