Trait {
	#name : #TGtWithPharoBehaviorProtocolCoderViewModel,
	#instVars : [
		'pharoBehaviorProtocolCoderViewModel'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> hasPharoBehaviorProtocolCoderViewModel [
	"Return a true if pharoBehaviorProtocolCoder view model is assigned to the receiver element, false otherwise"
	<return: #Boolean>

	^ pharoBehaviorProtocolCoderViewModel notNil
]

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> onPharoBehaviorProtocolCoderViewModelChanged [
	"Is sent when a new pharoBehaviorProtocolCoder view model is assigned to the element.
	Note: #onPharoBehaviorProtocolCoderViewModelChanged is sent before #subscribeToPharoBehaviorProtocolCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostPharoBehaviorProtocolCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self explicitRequirement
]

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> onPostPharoBehaviorProtocolCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToPharoBehaviorProtocolCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
]

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> pharoBehaviorProtocolCoderViewModel [
	"Return a not-null pharoBehaviorProtocolCoder view model assigned to the receiver element"
	self
		assert: [ pharoBehaviorProtocolCoderViewModel notNil ]
		description: [ 'pharoBehaviorProtocolCoder view model should be initialized' ].

	^ pharoBehaviorProtocolCoderViewModel
]

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> pharoBehaviorProtocolCoderViewModel: aPharoBehaviorProtocolCoderViewModel [
	"Set a not-null pharoBehaviorProtocolCoder view model assigned to the receiver element"
	self
		assert: [ aPharoBehaviorProtocolCoderViewModel notNil ]
		description: [ 'pharoBehaviorProtocolCoder view model must not be nil' ].

	pharoBehaviorProtocolCoderViewModel == aPharoBehaviorProtocolCoderViewModel 
		ifTrue: [ ^ self ].

	pharoBehaviorProtocolCoderViewModel ifNotNil: [ self unsubscribeFromPharoBehaviorProtocolCoderViewModel ].
	pharoBehaviorProtocolCoderViewModel := aPharoBehaviorProtocolCoderViewModel.

	self onPharoBehaviorProtocolCoderViewModelChanged.
	self subscribeToPharoBehaviorProtocolCoderViewModel.
	self onPostPharoBehaviorProtocolCoderViewModelChanged
]

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> subscribeToPharoBehaviorProtocolCoderViewModel [
	"Is sent after a new pharoBehaviorProtocolCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromPharoBehaviorProtocolCoderViewModel if elements subscribe to them"
]

{ #category : #'api - pharo behavior protocol coder view model' }
TGtWithPharoBehaviorProtocolCoderViewModel >> unsubscribeFromPharoBehaviorProtocolCoderViewModel [
	"Is sent before a new pharoBehaviorProtocolCoder view model is assigned to the element.
	Elements that subscribe to pharoBehaviorProtocolCoder view model in domain model are required to implement this methods."
]
