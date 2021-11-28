Class {
	#name : #GtStreamingCodersModel,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'monitor',
		'coders',
		'itemsStream',
		'codersStream'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Coder'
}

{ #category : #'api - announcer' }
GtStreamingCodersModel >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
]

{ #category : #'api - converting' }
GtStreamingCodersModel >> asAsyncStream [
	<return: #TAsyncStream>
	
	^ self codersStream
]

{ #category : #'api - accessing' }
GtStreamingCodersModel >> codersStream [
	"Return a stream of coders"
	<return: #TAsyncStream>

	^ codersStream asyncSimilarCopy
]

{ #category : #initialization }
GtStreamingCodersModel >> initialize [
	super initialize.

	monitor := Monitor new.
	coders := Dictionary new.
	itemsStream := AsyncEmptyStream new.
	codersStream := AsyncEmptyStream new
]

{ #category : #'api - accessing' }
GtStreamingCodersModel >> itemsStream [
	"Return a stream of items backing the coder"
	<return: #TAsyncStream>

	^ itemsStream asyncSimilarCopy
]

{ #category : #'private - accessing' }
GtStreamingCodersModel >> itemsStream: anAsyncStream dueTo: aReasonObject [
	"Change the items stream to a given one due to a provided reason.
	Please not that the new stream must not be the same stream as an existing #itemsStream"

	self
		assert: [ itemsStream ~~ anAsyncStream ]
		description: [ 'Must not pass the same stream as the current one' ]. 

	monitor critical: [
		itemsStream := anAsyncStream cached.
		codersStream := itemsStream map: [ :eachItem | self newCoderFor: eachItem ] cache: coders ].

	self notifyStreamChangedDueTo: aReasonObject
]

{ #category : #'private - instance creation' }
GtStreamingCodersModel >> newCoderFor: anObject [
	^ self subclassResponsibility
]

{ #category : #'private - notifying' }
GtStreamingCodersModel >> notifyStreamChangedDueTo: aReasonObject [
	self announce: (GtStreamingCodersStreamChanged new dueTo: aReasonObject)
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
