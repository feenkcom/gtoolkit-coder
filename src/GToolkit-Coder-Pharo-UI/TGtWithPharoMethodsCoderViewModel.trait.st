Trait {
	#name : #TGtWithPharoMethodsCoderViewModel,
	#instVars : [
		'pharoMethodsCoderViewModel'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> hasPharoMethodsCoderViewModel [
	"Return a true if pharoMethodsCoder view model is assigned to the receiver element, false otherwise"
	<return: #Boolean>

	^ pharoMethodsCoderViewModel notNil
]

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> onPharoMethodsCoderViewModelChanged [
	"Is sent when a new pharoMethodsCoder view model is assigned to the element.
	Note: #onPharoMethodsCoderViewModelChanged is sent before #subscribeToPharoMethodsCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostPharoMethodsCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self explicitRequirement
]

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> onPostPharoMethodsCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToPharoMethodsCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
]

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> pharoMethodsCoderViewModel [
	"Return a not-null pharoMethodsCoder view model assigned to the receiver element"
	self
		assert: [ pharoMethodsCoderViewModel notNil ]
		description: [ 'pharoMethodsCoder view model should be initialized' ].

	^ pharoMethodsCoderViewModel
]

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> pharoMethodsCoderViewModel: aPharoMethodsCoderViewModel [
	"Set a not-null pharoMethodsCoder view model assigned to the receiver element"
	self
		assert: [ aPharoMethodsCoderViewModel notNil ]
		description: [ 'pharoMethodsCoder view model must not be nil' ].

	pharoMethodsCoderViewModel == aPharoMethodsCoderViewModel 
		ifTrue: [ ^ self ].

	pharoMethodsCoderViewModel ifNotNil: [ self unsubscribeFromPharoMethodsCoderViewModel ].
	pharoMethodsCoderViewModel := aPharoMethodsCoderViewModel.

	self onPharoMethodsCoderViewModelChanged.
	self subscribeToPharoMethodsCoderViewModel.
	self onPostPharoMethodsCoderViewModelChanged
]

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> subscribeToPharoMethodsCoderViewModel [
	"Is sent after a new pharoMethodsCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromPharoMethodsCoderViewModel if elements subscribe to them"
]

{ #category : #'api - pharo methods coder view model' }
TGtWithPharoMethodsCoderViewModel >> unsubscribeFromPharoMethodsCoderViewModel [
	"Is sent before a new pharoMethodsCoder view model is assigned to the element.
	Elements that subscribe to pharoMethodsCoder view model in domain model are required to implement this methods."
]
