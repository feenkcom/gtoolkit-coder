Class {
	#name : #GtCodersAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coders'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCodersAnnouncement >> coders [
	^ coders
]

{ #category : #accessing }
GtCodersAnnouncement >> coders: anObject [
	coders := anObject
]
