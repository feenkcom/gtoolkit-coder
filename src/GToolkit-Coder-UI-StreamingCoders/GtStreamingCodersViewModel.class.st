Class {
	#name : #GtStreamingCodersViewModel,
	#superclass : #Object,
	#traits : 'TGtWithCodersModel',
	#classTraits : 'TGtWithCodersModel classTrait',
	#instVars : [
		'announcer',
		'monitor',
		'coderViewModels',
		'coderViewModelsStream',
		'pendingCommands',
		'scrollTarget'
	],
	#category : #'GToolkit-Coder-UI-StreamingCoders-View Model'
}

{ #category : #'api - announcer' }
GtStreamingCodersViewModel >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
]

{ #category : #'api - accessing' }
GtStreamingCodersViewModel >> coderViewModelsStream [
	<return: #TAsyncStream>

	^ coderViewModelsStream asyncSimilarCopy
]

{ #category : #'api - commands' }
GtStreamingCodersViewModel >> enqueueCommand: aViewModelCommand [
	monitor critical: [ 
		| theApplicableCoderViewModels |
		
		theApplicableCoderViewModels := OrderedCollection new.
		
		coderViewModels valuesDo: [ :eachCoderViewModel |
			(aViewModelCommand applicableTo: eachCoderViewModel)	
				ifTrue: [ theApplicableCoderViewModels add: eachCoderViewModel ] ].
			
		theApplicableCoderViewModels
			ifEmpty: [ pendingCommands add: aViewModelCommand ]
			ifNotEmpty: [ theApplicableCoderViewModels do: [ :eachCoderViewModel | aViewModelCommand applyOn: eachCoderViewModel ] ] ]
]

{ #category : #'api - scrolling' }
GtStreamingCodersViewModel >> hasScrollTarget [
	^ scrollTarget notNil
]

{ #category : #initialization }
GtStreamingCodersViewModel >> initialize [
	super initialize.

	monitor := Monitor new.
	coderViewModels := Dictionary new.
	pendingCommands := OrderedCollection new.
	coderViewModelsStream := AsyncEmptyStream new
]

{ #category : #'instance creation' }
GtStreamingCodersViewModel >> newCoderViewModelFor: aCoderModel [
	^ aCoderModel asCoderViewModel
]

{ #category : #'private - notifying' }
GtStreamingCodersViewModel >> notifyCoderViewModelsStreamChanged [
	self announce: GtStreamingCodersViewModelStreamChanged new
]

{ #category : #'private - event handling' }
GtStreamingCodersViewModel >> onCoderAdded: anAnnouncement [
	self privateFetchCoderViewModelFor: anAnnouncement coder.
	self updateCoderViewModelsStream
]

{ #category : #'api - coders model' }
GtStreamingCodersViewModel >> onCodersModelChanged [
	"Is sent when a new codersModel is assigned to the receiver.
	Note: #onCodersModelChanged is sent before #subscribeToCodersModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostCodersModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
	
	self updateCoderViewModelsStream
]

{ #category : #'private - event handling' }
GtStreamingCodersViewModel >> onCodersStreamChanged: anAnnouncement [
	self notifyCoderViewModelsStreamChanged
]

{ #category : #'private - accessing' }
GtStreamingCodersViewModel >> privateCoderViewModelsStream: anAsyncStream [
	coderViewModelsStream := anAsyncStream cached.
	self notifyCoderViewModelsStreamChanged
]

{ #category : #'private - accessing' }
GtStreamingCodersViewModel >> privateFetchCoderViewModelFor: aCoderModel [
	^ monitor critical: [				
		coderViewModels
			at: aCoderModel
			ifAbsentPut: [
				| aCoderViewModel theApplicableCommands |
				aCoderViewModel := self newCoderViewModelFor: aCoderModel.
				
				theApplicableCommands := pendingCommands select: [ :eachCommand | eachCommand applicableTo: aCoderViewModel ].
				pendingCommands removeAll: theApplicableCommands.
				theApplicableCommands do: [ :eachCommand | eachCommand applyOn: aCoderViewModel ].
				
				aCoderViewModel ] ]
]

{ #category : #'api - scrolling' }
GtStreamingCodersViewModel >> scrollTarget [
	^ scrollTarget
]

{ #category : #'api - scrolling' }
GtStreamingCodersViewModel >> scrollToTarget: aGtStreamingCoderViewModelScrollTarget [
	scrollTarget := aGtStreamingCoderViewModelScrollTarget.
	self announce: (GtStreamingCodersViewModelScrollTargetChanged new scrollTarget: scrollTarget)
]

{ #category : #'api - coders model' }
GtStreamingCodersViewModel >> subscribeToCodersModel [
	"Is sent after a new codersModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromCodersModel if the receiver subscribes to them"
	<modelSubscriber: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
	
	codersModel
		when: GtCodersCoderAdded
			send: #onCoderAdded:
			to: self;
		when: GtCodersStreamChanged
			send: #onCodersStreamChanged:
			to: self
]

{ #category : #'api - announcer' }
GtStreamingCodersViewModel >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - coders model' }
GtStreamingCodersViewModel >> unsubscribeFromCodersModel [
	"Is sent before a new codersModel is assigned to the receiver.
	Objects that subscribe to codersModel are required to implement this method."
	<modelUnsubscriber: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
	
	codersModel unsubscribe: self
]

{ #category : #'private - updating' }
GtStreamingCodersViewModel >> updateCoderViewModelsStream [
	monitor critical: [
		self privateCoderViewModelsStream: (codersModel codersStream map: [ :eachCoder | self privateFetchCoderViewModelFor: eachCoder ]) ]
]

{ #category : #'api - announcer' }
GtStreamingCodersViewModel >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtStreamingCodersViewModel >> when: anAnnouncementClass do: aBlock for: aSubscriber [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoForTemplate'>
	^ (self when: anAnnouncementClass do: aBlock)
		subscriber: aSubscriber;
		yourself
]

{ #category : #'api - announcer' }
GtStreamingCodersViewModel >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
