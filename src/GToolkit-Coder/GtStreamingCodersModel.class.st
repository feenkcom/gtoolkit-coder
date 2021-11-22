Class {
	#name : #GtStreamingCodersModel,
	#superclass : #Object,
	#traits : 'TGtOptions',
	#classTraits : 'TGtOptions classTrait',
	#instVars : [
		'announcer',
		'monitor',
		'coders'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - announcer' }
GtStreamingCodersModel >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
]

{ #category : #'api - converting' }
GtStreamingCodersModel >> asAsyncStream [
	<return: #TAsyncStream>
	
	^ self subclassResponsibility
]

{ #category : #initialization }
GtStreamingCodersModel >> initialize [
	super initialize.

	monitor := Monitor new.
	coders := Dictionary new
]

{ #category : #'private - instance creation' }
GtStreamingCodersModel >> newCoderFor: anObject [
	^ self subclassResponsibility
]

{ #category : #'private - notifying' }
GtStreamingCodersModel >> notifyChanged [
	self announce: (GtCodersCodersChanged new coders: self)
]

{ #category : #'private - instance creation' }
GtStreamingCodersModel >> privateFetchCoderFor: anObject [
	^ monitor critical: [
		coders
			at: anObject
			ifAbsentPut: [ self newCoderFor: anObject ] ]
]

{ #category : #'api - announcer' }
GtStreamingCodersModel >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - announcer' }
GtStreamingCodersModel >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtStreamingCodersModel >> when: anAnnouncementClass do: aBlock for: aSubscriber [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoForTemplate'>
	^ (self when: anAnnouncementClass do: aBlock)
		subscriber: aSubscriber;
		yourself
]

{ #category : #'api - announcer' }
GtStreamingCodersModel >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
