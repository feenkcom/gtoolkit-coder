Class {
	#name : #GtClassCoderMethodNavigationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'method',
		'source'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderMethodNavigationAnnouncement >> method [
	^ method
]

{ #category : #accessing }
GtClassCoderMethodNavigationAnnouncement >> method: aMethod [
	method := aMethod
]

{ #category : #accessing }
GtClassCoderMethodNavigationAnnouncement >> source [
	^ source
]

{ #category : #accessing }
GtClassCoderMethodNavigationAnnouncement >> source: anObject [
	source := anObject
]
