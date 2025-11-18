Trait {
	#name : #TGtWithCoderToolViewModel,
	#instVars : [
		'coderToolViewModel'
	],
	#category : #'GToolkit-Coder-UI-! Core - View Models'
}

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> coderToolViewModel [
	"Return a not-null coderTool view model assigned to the receiver element"
	self
		assert: [ coderToolViewModel notNil ]
		description: [ 'coderTool view model should be initialized' ].

	^ coderToolViewModel
]

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> coderToolViewModel: aCoderToolViewModel [
	"Set a not-null coderTool view model assigned to the receiver element"
	self
		assert: [ aCoderToolViewModel notNil ]
		description: [ 'coderTool view model must not be nil' ].

	coderToolViewModel == aCoderToolViewModel 
		ifTrue: [ ^ self ].

	coderToolViewModel ifNotNil: [ self unsubscribeFromCoderToolViewModel ].
	coderToolViewModel := aCoderToolViewModel.

	self onCoderToolViewModelChanged.
	self subscribeToCoderToolViewModel.
	self onPostCoderToolViewModelChanged
]

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> hasCoderToolViewModel [
	"Return a true if coderTool view model is assigned to the receiver element, false otherwise"
	<return: #Boolean>

	^ coderToolViewModel notNil
]

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> onCoderToolViewModelChanged [
	"Is sent when a new coderTool view model is assigned to the element.
	Note: #onCoderToolViewModelChanged is sent before #subscribeToCoderToolViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostCoderToolViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self explicitRequirement
]

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> onPostCoderToolViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToCoderToolViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
]

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> subscribeToCoderToolViewModel [
	"Is sent after a new coderTool view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromCoderToolViewModel if elements subscribe to them"
]

{ #category : #'api - coder tool view model' }
TGtWithCoderToolViewModel >> unsubscribeFromCoderToolViewModel [
	"Is sent before a new coderTool view model is assigned to the element.
	Elements that subscribe to coderTool view model in domain model are required to implement this methods."
]
