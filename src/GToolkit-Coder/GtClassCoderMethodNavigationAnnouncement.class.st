Class {
	#name : #GtClassCoderMethodNavigationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'method'
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
