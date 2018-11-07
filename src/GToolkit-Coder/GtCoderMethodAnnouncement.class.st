Class {
	#name : #GtCoderMethodAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderMethodAnnouncement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderMethodAnnouncement >> coder: methodCoder [
	coder := methodCoder
]
