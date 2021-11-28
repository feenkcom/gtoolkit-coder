Trait {
	#name : #TGtWithStreamingCodersModel,
	#instVars : [
		'streamingCodersModel'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Coder'
}

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> hasStreamingCodersModel [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ streamingCodersModel notNil
]

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> onPostStreamingCodersModelChanged [
	"I am an optional hook method that is sent after #subscribeToStreamingCodersModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> onStreamingCodersModelChanged [
	"Is sent when a new streamingCodersModel is assigned to the receiver.
	Note: #onStreamingCodersModelChanged is sent before #subscribeToStreamingCodersModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostStreamingCodersModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> streamingCodersModel [
	"Return a not-null streamingCodersModel assigned to the receiver"
	<modelGetter: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ streamingCodersModel notNil ]
		description: [ 'streamingCodersModel should be initialized' ].

	^ streamingCodersModel
]

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> streamingCodersModel: aStreamingCodersModel [
	"Set a not-null streamingCodersModel assigned to the receiver"
	<modelSetter: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aStreamingCodersModel notNil ]
		description: [ 'streamingCodersModel must not be nil' ].

	streamingCodersModel == aStreamingCodersModel
		ifTrue: [ ^ self ].

	streamingCodersModel ifNotNil: [ self unsubscribeFromStreamingCodersModel ].
	streamingCodersModel := aStreamingCodersModel.

	self onStreamingCodersModelChanged.
	self subscribeToStreamingCodersModel.
	self onPostStreamingCodersModelChanged
]

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> subscribeToStreamingCodersModel [
	"Is sent after a new streamingCodersModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromStreamingCodersModel if the receiver subscribes to them"
	<modelSubscriber: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - streaming coders model' }
TGtWithStreamingCodersModel >> unsubscribeFromStreamingCodersModel [
	"Is sent before a new streamingCodersModel is assigned to the receiver.
	Objects that subscribe to streamingCodersModel are required to implement this method."
	<modelUnsubscriber: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
