Class {
	#name : #GtCoderAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderAnnouncement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderAnnouncement >> coder: methodCoder [
	coder := methodCoder
]
