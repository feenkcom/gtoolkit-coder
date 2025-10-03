Class {
	#name : #GtSourceCoderModificationIndicator,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtWithTextualCoderViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtWithTextualCoderViewModel classTrait',
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'api - visibility' }
GtSourceCoderModificationIndicator >> hide [
	self visibility: BlVisibility gone
]

{ #category : #initialization }
GtSourceCoderModificationIndicator >> initialize [
	super initialize.

	self background: self theme status changesBackgroundColor.
	self preventMeAndChildrenMouseEvents.
	self id: GtTextualCoderModificationIndicatorId.
	self
		withAsyncPromiseDo: [ :anElementPromise | 
			anElementPromise
				whenSuccess: [ :anIndicator :isModified | self onPromiseSuccess: isModified ];
				whenError: [ :anIndicator :anException | self onPromiseError: anException ] ]
]

{ #category : #'private - event handling' }
GtSourceCoderModificationIndicator >> onPromiseError: anException [ 
]

{ #category : #'private - event handling' }
GtSourceCoderModificationIndicator >> onPromiseSuccess: isModified [
	isModified ifTrue: [ self show ] ifFalse: [ self hide ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderModificationIndicator >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self updateElement
]

{ #category : #'private - event handling' }
GtSourceCoderModificationIndicator >> onViewModelTextChanged: anAnnouncement [
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	anAnnouncement textualCoderViewModel = self textualCoderViewModel
		ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - visibility' }
GtSourceCoderModificationIndicator >> show [
	self visibility: BlVisibility visible
]

{ #category : #'api - textual coder view model' }
GtSourceCoderModificationIndicator >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"

	self textualCoderViewModel weak
		when: GtTextualCoderViewModelTextChanged
			send: #onViewModelTextChanged:
			to: self
]

{ #category : #'api - textual coder view model' }
GtSourceCoderModificationIndicator >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
	
	self textualCoderViewModel unsubscribe: self
]

{ #category : #'api - textual coder view model' }
GtSourceCoderModificationIndicator >> updateElement [
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	self asyncPromise promise: self textualCoderViewModel isTextModifiedPromise
]

{ #category : #'api - initialization' }
GtSourceCoderModificationIndicator >> withVerticalLeftIgnoredLayout [
	self
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignLeft.
			c horizontal exact: 5.
			c vertical matchParent.
			c margin: (BlInsets left: 8) ]
]
