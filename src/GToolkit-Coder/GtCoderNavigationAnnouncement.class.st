Class {
	#name : #GtCoderNavigationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coder',
		'source'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationAnnouncement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderNavigationAnnouncement >> coder: aCoder [
	coder := aCoder
]

{ #category : #accessing }
GtCoderNavigationAnnouncement >> source [
	^ source
]

{ #category : #accessing }
GtCoderNavigationAnnouncement >> source: anObject [
	source := anObject
]
