Trait {
	#name : #TGtWithCoderModel,
	#instVars : [
		'coderModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #'api - coder model' }
TGtWithCoderModel >> coderModel [
	"Return a not-null coder model assigned to the receiver view model"
	self
		assert: [ coderModel notNil ]
		description: [ 'coder model should be initialized' ].

	^ coderModel
]

{ #category : #'api - coder model' }
TGtWithCoderModel >> coderModel: aCoderModel [
	"Set a not-null coder domain model assigned to the receiver view model"
	self
		assert: [ aCoderModel notNil ]
		description: [ 'coder model must not be nil' ].

	coderModel == aCoderModel 
		ifTrue: [ ^ self ].

	coderModel ifNotNil: [ self unsubscribeFromCoderModel ].
	coderModel := aCoderModel.

	self onCoderModelChanged.
	self subscribeToCoderModel
]

{ #category : #'api - coder model' }
TGtWithCoderModel >> hasCoder [
	"Return a true if coder model is assigned to the receiver, false otherwise"
	<return: #Boolean>

	^ coderModel notNil
]

{ #category : #'api - coder model' }
TGtWithCoderModel >> onCoderModelChanged [
	"Is sent when a new coder model is assigned to the view model"
	
	self explicitRequirement
]

{ #category : #'api - coder model' }
TGtWithCoderModel >> subscribeToCoderModel [
	"Is sent after a new coder model is assigned to the view model.
	It is required to unsubscribe from the domain model by implementing
	#unsubscribeFromCoderModel if view model subscribes to them"
]

{ #category : #'api - coder model' }
TGtWithCoderModel >> unsubscribeFromCoderModel [
	"Is sent before a new coder model is assigned to the view model.
	View models that subscribe to coder model are required to implement this methods"
]
