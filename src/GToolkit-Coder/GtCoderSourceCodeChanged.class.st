"
Is sent when coder's source code changes
"
Class {
	#name : #GtCoderSourceCodeChanged,
	#superclass : #GtCoderAnnouncement,
	#instVars : [
		'source',
		'updateStragegy'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #testing }
GtCoderSourceCodeChanged >> isSynchronous [
	^ self updateStragegy notNil
		and: [ self updateStragegy isSynchronous ]
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> source [
	^ source
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStragegy [
	^ updateStragegy
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStragegy: anUpdateStragegy [
	updateStragegy := anUpdateStragegy
]
