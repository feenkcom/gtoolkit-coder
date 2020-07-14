"
I am by the ${GtSourceCoder}$ sent when the AddOn stylers changed
"
Class {
	#name : #GtCoderStylerChanged,
	#superclass : #GtCoderAnnouncement,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderStylerChanged >> stylers [
	^ stylers
]

{ #category : #accessing }
GtCoderStylerChanged >> stylers: anObject [
	stylers := anObject
]
