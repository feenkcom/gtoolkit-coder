Trait {
	#name : #TGtWithTextualCoderViewModel,
	#instVars : [
		'textualCoderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> hasTextualCoderViewModel [
	"Return a true if textualCoder view model is assigned to the receiver element, false otherwise"
	<return: #Boolean>

	^ textualCoderViewModel notNil
]

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> onPostTextualCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToTextualCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
]

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self explicitRequirement
]

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"
]

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> textualCoderViewModel [
	"Return a not-null textualCoder view model assigned to the receiver element"
	self
		assert: [ textualCoderViewModel notNil ]
		description: [ 'textualCoder view model should be initialized' ].

	^ textualCoderViewModel
]

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> textualCoderViewModel: aTextualCoderViewModel [
	"Set a not-null textualCoder view model assigned to the receiver element"
	self
		assert: [ aTextualCoderViewModel notNil ]
		description: [ 'textualCoder view model must not be nil' ].

	textualCoderViewModel == aTextualCoderViewModel 
		ifTrue: [ ^ self ].

	textualCoderViewModel ifNotNil: [ self unsubscribeFromTextualCoderViewModel ].
	textualCoderViewModel := aTextualCoderViewModel.

	self onTextualCoderViewModelChanged.
	self subscribeToTextualCoderViewModel.
	self onPostTextualCoderViewModelChanged
]

{ #category : #'api - textual coder view model' }
TGtWithTextualCoderViewModel >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
]
