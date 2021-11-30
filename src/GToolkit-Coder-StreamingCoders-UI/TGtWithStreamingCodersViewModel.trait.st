Trait {
	#name : #TGtWithStreamingCodersViewModel,
	#instVars : [
		'streamingCodersViewModel'
	],
	#category : #'GToolkit-Coder-StreamingCoders-UI-Coder'
}

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> hasStreamingCodersViewModel [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ streamingCodersViewModel notNil
]

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> onPostStreamingCodersViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToStreamingCodersViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> onStreamingCodersViewModelChanged [
	"Is sent when a new streamingCodersViewModel is assigned to the receiver.
	Note: #onStreamingCodersViewModelChanged is sent before #subscribeToStreamingCodersViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostStreamingCodersViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> streamingCodersViewModel [
	"Return a not-null streamingCodersViewModel assigned to the receiver"
	<modelGetter: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ streamingCodersViewModel notNil ]
		description: [ 'streamingCodersViewModel should be initialized' ].

	^ streamingCodersViewModel
]

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> streamingCodersViewModel: aStreamingCodersViewModel [
	"Set a not-null streamingCodersViewModel assigned to the receiver"
	<modelSetter: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aStreamingCodersViewModel notNil ]
		description: [ 'streamingCodersViewModel must not be nil' ].

	streamingCodersViewModel == aStreamingCodersViewModel
		ifTrue: [ ^ self ].

	streamingCodersViewModel ifNotNil: [ self unsubscribeFromStreamingCodersViewModel ].
	streamingCodersViewModel := aStreamingCodersViewModel.

	self onStreamingCodersViewModelChanged.
	self subscribeToStreamingCodersViewModel.
	self onPostStreamingCodersViewModelChanged
]

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> subscribeToStreamingCodersViewModel [
	"Is sent after a new streamingCodersViewModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromStreamingCodersViewModel if the receiver subscribes to them"
	<modelSubscriber: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - streaming coders view model' }
TGtWithStreamingCodersViewModel >> unsubscribeFromStreamingCodersViewModel [
	"Is sent before a new streamingCodersViewModel is assigned to the receiver.
	Objects that subscribe to streamingCodersViewModel are required to implement this method."
	<modelUnsubscriber: #streamingCoders>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
