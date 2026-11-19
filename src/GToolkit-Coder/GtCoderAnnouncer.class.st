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

{ #category : #announce }
GtCoderAnnouncer >> announce: anAnnouncement afterNotifying: aGtTextualCoderNotifier [
	"The direct notifier is treated like one more subscriber: it is informed under the same monitor and suppression as the subscribers, so it stays serialized with them, and it is isolated like a subscription: an unhandled error is debugged in a separate process and the subscribers still receive the announcement"

	monitor
		critical: [ (suppressedAnnouncements includes: anAnnouncement class) ifTrue: [ ^ self ].
			[ [ anAnnouncement notifyThrough: aGtTextualCoderNotifier ]
				on: UnhandledError
				fork: [ :anException | anException pass ] ]
				ensure: [ super announce: anAnnouncement ] ]
]

{ #category : #initialization }
GtCoderAnnouncer >> initialize [
	super initialize.
	
	monitor := Mutex new.
	suppressedAnnouncements := #()
]

{ #category : #announce }
GtCoderAnnouncer >> suppress: aCollectionOfAnnouncementClasses during: aBlock [
	monitor critical: [
		| aPreviousSuppressedAnnouncements |
		aPreviousSuppressedAnnouncements := suppressedAnnouncements copy.
		suppressedAnnouncements := (suppressedAnnouncements, aCollectionOfAnnouncementClasses asOrderedCollection) asSet.
		aBlock ensure: [ suppressedAnnouncements := aPreviousSuppressedAnnouncements ] ]
]
