Class {
	#name : #GtCoderDrillDownAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderDrillDownAnnouncement class >> forCoder: aCoder [
	^ self new
		coder: aCoder;
		yourself
]

{ #category : #accessing }
GtCoderDrillDownAnnouncement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderDrillDownAnnouncement >> coder: anObject [
	coder := anObject
]
