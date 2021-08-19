Class {
	#name : 'GtCodersAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'coders',
		'source'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : 'accessing' }
GtCodersAnnouncement >> coders [
	^ coders
]

{ #category : 'accessing' }
GtCodersAnnouncement >> coders: anObject [
	coders := anObject
]

{ #category : 'accessing' }
GtCodersAnnouncement >> source [
	^ source
]

{ #category : 'accessing' }
GtCodersAnnouncement >> source: anObject [
	source := anObject
]
