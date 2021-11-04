"
Is sent when coder's source code changes


"
Class {
	#name : #GtCoderSourceCodeChanged,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'updateStragegy',
		'newText'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #testing }
GtCoderSourceCodeChanged >> isSynchronous [
	^ self updateStrategy notNil
		and: [ self updateStrategy isSynchronous ]
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> newText [

	^ newText
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> newText: anObject [

	newText := anObject
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> source [
	^ self updateStrategy source
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStrategy [
	^ updateStragegy
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStrategy: anUpdateStragegy [
	updateStragegy := anUpdateStragegy
]
