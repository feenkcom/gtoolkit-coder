Class {
	#name : #GtCoderAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'suppressedAnnouncements',
		'monitor'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #announce }
GtCoderAnnouncer >> announce: anAnnouncement [
	monitor critical: [
		(suppressedAnnouncements includes: anAnnouncement class)
			ifTrue: [ ^ self ].
		super announce: anAnnouncement ]
]

{ #category : #initialization }
GtCoderAnnouncer >> initialize [
	super initialize.
	
	monitor := Monitor new.
	suppressedAnnouncements := #()
]

{ #category : #announce }
GtCoderAnnouncer >> suppress: aCollectionOfAnnouncementClasses during: aBlock [
	monitor critical: [
		| aPreviousSuppressedAnnouncements |
		aPreviousSuppressedAnnouncements := suppressedAnnouncements copy.
		suppressedAnnouncements := (suppressedAnnouncements, aCollectionOfAnnouncementClasses asCollection) asSet.
		aBlock ensure: [ suppressedAnnouncements := aPreviousSuppressedAnnouncements ] ]
]
