Class {
	#name : #GtCoderAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'suppressedAnnouncements'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #announce }
GtCoderAnnouncer >> announce: anAnnouncement [
	(suppressedAnnouncements includes: anAnnouncement class)
		ifTrue: [ ^ self ].
		
	super announce: anAnnouncement
]

{ #category : #initialization }
GtCoderAnnouncer >> initialize [
	super initialize.
	
	suppressedAnnouncements := #()
]

{ #category : #announce }
GtCoderAnnouncer >> suppress: aCollectionOfAnnouncementClasses during: aBlock [
	| aPreviousSuppressedAnnouncements |
	
	aPreviousSuppressedAnnouncements := suppressedAnnouncements copy.
	suppressedAnnouncements := (suppressedAnnouncements, aCollectionOfAnnouncementClasses asCollection) asSet.
	aBlock ensure: [ suppressedAnnouncements := aPreviousSuppressedAnnouncements ]
]
