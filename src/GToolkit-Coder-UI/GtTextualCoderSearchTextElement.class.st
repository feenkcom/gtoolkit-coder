Class {
	#name : #GtTextualCoderSearchTextElement,
	#superclass : #BrSearchTextElement,
	#traits : 'TGtWithTextualCoderViewModel',
	#classTraits : 'TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'marker',
		'context'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #initialization }
GtTextualCoderSearchTextElement >> initialize [
	super initialize.
	self initializeMarker.
	self initializeEventHandlers.

	self hFitContentLimited
]

{ #category : #initialization }
GtTextualCoderSearchTextElement >> initializeEventHandlers [
	self
		when: BrSearchTextPatternWish
		do: [ :anEvent | self onBrSearchTextPatternWish: anEvent ].
	self
		when: BrSearchTextNoPatternWish
		do: [ :anEvent | self onBrSearchTextNoPatternWish: anEvent ].
	self
		when: BrSearchTextNextOccurenceWish
		do: [ :anEvent | self onBrSearchTextNextOccurenceWish: anEvent ].
	self
		when: BrSearchTextPreviousOccurenceWish
		do: [ :anEvent | self onBrSearchTextPreviousOccurenceWish: anEvent ].
	self
		when: BrSearchTextEndWish
		do: [ :anEvent | self onBrSearchTextEndWish: anEvent ]
]

{ #category : #initialization }
GtTextualCoderSearchTextElement >> initializeMarker [
	marker := BrEditorSearchTextMarker new
			computation: (BrEditorSearchTextAsyncFutureComputation new
					executionConfiguration: (AsyncFutureExecutionConfiguration new
							customGroup: #SearchText;
							defaultPriority)).

	marker
		when: BrEditorSearchTextFinishedAnnouncement
		send: #onBrEditorSearchTextFinishedAnnouncement:
		to: self
]

{ #category : #private }
GtTextualCoderSearchTextElement >> newMarkerContext [
	self hasTextualCoderViewModel ifFalse: [ ^ nil ].

	^ BrEditorSearchTextMarkerContext new
		fromCoderViewModel: self textualCoderViewModel;
		element: self
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onBrEditorSearchTextFinishedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self index: anAnnouncement selectedIndex total: anAnnouncement itemsCount ]
]

{ #category : #initialization }
GtTextualCoderSearchTextElement >> onBrSearchTextEndWish: anEvent [
	| aContext aRange aSelection |
	anEvent consumed: true.
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	aContext := context ifNil: [ ^ self ].
	context := nil.

	marker unmark: aContext.
	aRange := aContext selectedRange.
	aRange ifNil: [ ^ self ].

	aSelection := BlCompositeSelection new select: aRange first - 1 to: aRange last.
	self textualCoderViewModel
		announce: (GtTextualCoderViewModelSelectionChanged new
				shouldUpdateCursor: true;
				selection: aSelection;
				source: self textualCoderViewModel);
		announce: (GtTextualCoderViewModelFocusChanged new
				focused: true;
				source: self textualCoderViewModel).
	anEvent currentTarget fireEvent: BrDropdownHideWish new
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onBrSearchTextNextOccurenceWish: anEvent [
	| aContext |
	anEvent consumed: true.
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	aContext := context ifNil: [ ^ self ].

	marker markNext: aContext.
	self textualCoderViewModel
		scrollToLine: aContext selectedLine
		withCharacterPosition: aContext selectedStartPosition
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onBrSearchTextNoPatternWish: anEvent [
	| aContext |
	anEvent consumed: true.

	aContext := context.
	context := nil.
	aContext ifNil: [ ^ self ].

	marker unmark: aContext
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onBrSearchTextPatternWish: anEvent [
	| aContext |
	anEvent consumed: true.

	aContext := self newMarkerContext.
	aContext ifNil: [ ^ self ].

	aContext pattern: anEvent pattern.
	context := aContext.
	marker mark: aContext
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onBrSearchTextPreviousOccurenceWish: anEvent [
	| aContext |
	anEvent consumed: true.
	self hasTextualCoderViewModel ifFalse: [ ^ self ].
	aContext := context ifNil: [ ^ self ].

	marker markPrevious: aContext.
	self textualCoderViewModel
		scrollToLine: aContext selectedLine
		withCharacterPosition: aContext selectedStartPosition
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onGtSourceCoderViewModelSearchTextCancelRequested: anAnnouncement [
	| aContext |
	anAnnouncement consumed: true.
	aContext := context.
	aContext ifNil: [ ^ self ].
	marker unmark: aContext
]

{ #category : #'private - event management' }
GtTextualCoderSearchTextElement >> onGtSourceCoderViewModelSearchTextRequested: anAnnouncement [
	anAnnouncement consumed ifTrue: [ ^ self ].
	anAnnouncement consumed: true.

	self editorDo: [ :anEditor | anEditor requestFocus ]
]

{ #category : #'api - textual coder view model' }
GtTextualCoderSearchTextElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	
]

{ #category : #'api - textual coder view model' }
GtTextualCoderSearchTextElement >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"

	self textualCoderViewModel weak
		when: GtSourceCoderViewModelSearchTextRequested
			send: #onGtSourceCoderViewModelSearchTextRequested:
			to: self;
		when: GtSourceCoderViewModelSearchTextCancelRequested
			send: #onGtSourceCoderViewModelSearchTextCancelRequested:
			to: self
]

{ #category : #'api - textual coder view model' }
GtTextualCoderSearchTextElement >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."

	self textualCoderViewModel unsubscribe: self
]
