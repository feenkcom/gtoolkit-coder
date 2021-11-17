Trait {
	#name : #TGtWithCodersModel,
	#instVars : [
		'codersModel'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - coders model' }
TGtWithCodersModel >> codersModel [
	"Return a not-null codersModel assigned to the receiver"
	<modelGetter: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ codersModel notNil ]
		description: [ 'codersModel should be initialized' ].

	^ codersModel
]

{ #category : #'api - coders model' }
TGtWithCodersModel >> codersModel: aCodersModel [
	"Set a not-null codersModel assigned to the receiver"
	<modelSetter: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aCodersModel notNil ]
		description: [ 'codersModel must not be nil' ].

	codersModel == aCodersModel
		ifTrue: [ ^ self ].

	codersModel ifNotNil: [ self unsubscribeFromCodersModel ].
	codersModel := aCodersModel.

	self onCodersModelChanged.
	self subscribeToCodersModel.
	self onPostCodersModelChanged
]

{ #category : #'api - coders model' }
TGtWithCodersModel >> hasCodersModel [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ codersModel notNil
]

{ #category : #'api - coders model' }
TGtWithCodersModel >> onCodersModelChanged [
	"Is sent when a new codersModel is assigned to the receiver.
	Note: #onCodersModelChanged is sent before #subscribeToCodersModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostCodersModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - coders model' }
TGtWithCodersModel >> onPostCodersModelChanged [
	"I am an optional hook method that is sent after #subscribeToCodersModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - coders model' }
TGtWithCodersModel >> subscribeToCodersModel [
	"Is sent after a new codersModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromCodersModel if the receiver subscribes to them"
	<modelSubscriber: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - coders model' }
TGtWithCodersModel >> unsubscribeFromCodersModel [
	"Is sent before a new codersModel is assigned to the receiver.
	Objects that subscribe to codersModel are required to implement this method."
	<modelUnsubscriber: #codersModel>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
