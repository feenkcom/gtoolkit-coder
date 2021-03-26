Trait {
	#name : #TGtWithPharoBehaviorCoderViewModel,
	#instVars : [
		'pharoBehaviorCoderViewModel'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> hasPharoBehaviorCoderViewModel [
	"Return a true if pharoBehaviorCoder view model is assigned to the receiver element, false otherwise"
	<return: #Boolean>

	^ pharoBehaviorCoderViewModel notNil
]

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> onPharoBehaviorCoderViewModelChanged [
	"Is sent when a new pharoBehaviorCoder view model is assigned to the element.
	Note: #onPharoBehaviorCoderViewModelChanged is sent before #subscribeToPharoBehaviorCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostPharoBehaviorCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self explicitRequirement
]

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> onPostPharoBehaviorCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToPharoBehaviorCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
]

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> pharoBehaviorCoderViewModel [
	"Return a not-null pharoBehaviorCoder view model assigned to the receiver element"
	self
		assert: [ pharoBehaviorCoderViewModel notNil ]
		description: [ 'pharoBehaviorCoder view model should be initialized' ].

	^ pharoBehaviorCoderViewModel
]

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> pharoBehaviorCoderViewModel: aPharoBehaviorCoderViewModel [
	"Set a not-null pharoBehaviorCoder view model assigned to the receiver element"
	self
		assert: [ aPharoBehaviorCoderViewModel notNil ]
		description: [ 'pharoBehaviorCoder view model must not be nil' ].

	pharoBehaviorCoderViewModel == aPharoBehaviorCoderViewModel 
		ifTrue: [ ^ self ].

	pharoBehaviorCoderViewModel ifNotNil: [ self unsubscribeFromPharoBehaviorCoderViewModel ].
	pharoBehaviorCoderViewModel := aPharoBehaviorCoderViewModel.

	self onPharoBehaviorCoderViewModelChanged.
	self subscribeToPharoBehaviorCoderViewModel.
	self onPostPharoBehaviorCoderViewModelChanged
]

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> subscribeToPharoBehaviorCoderViewModel [
	"Is sent after a new pharoBehaviorCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromPharoBehaviorCoderViewModel if elements subscribe to them"
]

{ #category : #'api - pharo behavior coder view model' }
TGtWithPharoBehaviorCoderViewModel >> unsubscribeFromPharoBehaviorCoderViewModel [
	"Is sent before a new pharoBehaviorCoder view model is assigned to the element.
	Elements that subscribe to pharoBehaviorCoder view model in domain model are required to implement this methods."
]
