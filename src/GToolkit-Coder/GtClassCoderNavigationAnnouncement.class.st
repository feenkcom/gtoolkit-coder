Class {
	#name : #GtClassCoderNavigationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'method'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderNavigationAnnouncement >> method [
	^ method
]

{ #category : #accessing }
GtClassCoderNavigationAnnouncement >> method: aMethod [
	method := aMethod
]
