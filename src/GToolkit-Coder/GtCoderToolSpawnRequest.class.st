Class {
	#name : #GtCoderToolSpawnRequest,
	#superclass : #GtCoderAnnouncement,
	#instVars : [
		'tool',
		'spawnDestination'
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
