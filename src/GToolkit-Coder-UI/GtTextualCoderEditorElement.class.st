Class {
	#name : #GtTextualCoderEditorElement,
	#superclass : #BrEditor,
	#traits : 'TBlAssertUIProcess + TGtWithTextualCoderViewModel',
	#classTraits : 'TBlAssertUIProcess classTrait + TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'completion',
		'evaluationHighlighter',
		'evaluationPrinter',
		'shortcuts',
		'cursorsUpdater',
		'textUpdater'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> attachSpace [
	super attachSpace.
	
	GtTextualCoderEditorElementAttachedSpaceSignal emit
]

{ #category : #'api - textual coder view model' }
GtTextualCoderEditorElement >> coderViewModel: aTextualCoderViewModel [
	self textualCoderViewModel: aTextualCoderViewModel
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> computeTextForUpdateForTextChangedEvent: aGtTextualCoderViewModelTextChanged [ 
	"In case the editor has a text edit command we determine 
	the updated text by editing the text currently in the
	editor. If no edit command is present in the event,
	we take the text from the event. We use the edit command
	to avoid setting the text from the event which is not 
	styled, and can cause flickerings."
	
	^ aGtTextualCoderViewModelTextChanged hasTextEditCommand
		ifTrue: [ 
			| editCommand|
			editCommand :=  aGtTextualCoderViewModelTextChanged textEditCommand.
			self editedTextBasedOnEditCommand: editCommand.  ]
		ifFalse: [ 
			aGtTextualCoderViewModelTextChanged text copy ]
]

{ #category : #'instance creation' }
GtTextualCoderEditorElement >> createContextMenuContent [
	"wait for the addons to be computed"

	| theContextMenu aContextMenuPromise |
	theContextMenu := GtCoderContextMenuContent new editorElement: self.

	aContextMenuPromise := self textualCoderViewModel addOns
			asyncThen: [ :theAddOns | 
				| theItems theContextMenuAstAddons |
				"extra context menu items that depend on ast and view model state such as selection"
				theContextMenuAstAddons := self textualCoderViewModel
						computeContextMenuAstAddOns.
				theItems := theAddOns contextMenuActions, theContextMenuAstAddons contextMenuActions.
				theItems := theItems reject: [ :e | e title isNil ].

				theContextMenu
					enqueueTask: (BlTaskAction new action: [ theContextMenu items: theItems ]) ].

	self enqueueTask: (BlPromiseTask new promise: aContextMenuPromise).

	^ theContextMenu
]

{ #category : #initialization }
GtTextualCoderEditorElement >> defaultTextEditorMode [
	^ BrTextEditorEditableCodeMode new
]

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> detachSpace [
	super detachSpace.
	
	GtTextualCoderEditorElementDetachedSpaceSignal emit
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> editedTextBasedOnEditCommand: aTextEditCommand [
	| modifiedText|
	"self haltOnce."

	modifiedText := self text copy.
	aTextEditCommand applyTextChangeOn: modifiedText. 
	^ modifiedText  
]

{ #category : #private }
GtTextualCoderEditorElement >> hideHighlighters [
	self text clearAttributes: [ :eachAttribute | 
		eachAttribute isKindOf: GtSourceCoderErrorAttribute ].
	evaluationHighlighter hideResultSynchronously.
	evaluationPrinter hideResultSynchronously.
]

{ #category : #initialization }
GtTextualCoderEditorElement >> initialize [
	super initialize.
	
	self
		aptitude: BrGlamorousCodeEditorAptitude + (BrGlamorousWithContextMenuAptitude content: [ self createContextMenuContent ]);
		padding: BlInsets empty;
		hMatchParent;
		vFitContent.

	self id: GtSourceCoderEditorId.

	shortcuts := #().
	completion := GtCompletionController on: self.

	evaluationHighlighter := GtSourceCoderEvaluationHighlighter new editorElement: self.
	evaluationPrinter := GtSourceCoderEvaluationPrinter new editorElement: self.
	
	cursorsUpdater := BrElementUpdater new
		element: self;
		action: (MessageSend receiver: self selector: #privateUpdateCursors:announcement:).

	textUpdater := BrElementUpdater new
		element: self;
		action: (MessageSend receiver: self selector: #privateUpdateText:announcement:).

	self initializeListeners.
	
	self withAsyncPromiseDo: [ :anElementPromise |
			anElementPromise
				whenSuccess: [ :anEditorElement :anEditorState | anEditorElement privateUpdateEditorState: anEditorState ];
				whenError: [ :anEditorElement :anEditorState |  ];
				whenPending: [ :anEditorElement | ] ]
]

{ #category : #initialization }
GtTextualCoderEditorElement >> initializeListeners [
	self when: BlFocusInEvent do: [ :anEvent |
		self textualCoderViewModel focused: true from: self ].
	self when: BlFocusOutEvent do: [ :anEvent |
		"when elements are removed from the scene graph due to tab switching or scrolling they lose focus.
		We are only interested when focus is lost explicitly via user interaction"
		anEvent isDueToRemoval
			ifFalse: [ self textualCoderViewModel focused: false from: self ] ].

	self editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self onTextModifiedDueToEvent:  anEvent ].

	self editor
		when: BrTextEditorCursorChangedEvent 
		do: [ :anEvent | self textualCoderViewModel cursors: anEvent cursors from: self ].

	self editor
		when: BrTextEditorSelectionChangedEvent 
		do: [ :anEvent | self textualCoderViewModel selection: anEvent selection from: self ].

	self editor
		when: BrTextEditorTextStyledEvent
		do: [ :anEvent | self textualCoderViewModel styledText: anEvent styledText ]
]

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	GtTextualCoderEditorElementAddedToSceneGraphSignal emit
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onCodeEvaluated: anEvaluationAnnouncement [
	(anEvaluationAnnouncement requesterObject isCoderViewModel: self textualCoderViewModel) 
		ifFalse: [ ^ self ].

	evaluationHighlighter displayResult: anEvaluationAnnouncement evaluationResult.
	evaluationPrinter hideResult
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onCoderParseError: aGtCoderParseError [
	(aGtCoderParseError requesterObject 
		isUndefinedOrCoderViewModel: self textualCoderViewModel) 
			ifFalse: [ ^ self ].

	"A parse error can be notifying from a non-UI thread"
	self enqueueTask: (BlTaskAction new action: [
		self 
			reportParseError: aGtCoderParseError errorMessage 
			at: aGtCoderParseError location ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onCoderViewModelFocused: aBoolean [
	aBoolean
		ifTrue: [ self requestFocus ]
		ifFalse: [ self loseFocus ]
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onFocusChangedAnnouncement: anAnnouncement [
	anAnnouncement source == self ifTrue: [ ^ self ].

	anAnnouncement source == self textualCoderViewModel ifFalse: [ ^ self ].

	self
		enqueueTask: (BlTaskAction new
				action: [ self onCoderViewModelFocused: anAnnouncement focused ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onObjectSpawnRequest: anAnnouncement [
	(anAnnouncement requesterObject isCoderViewModel: self textualCoderViewModel) 
		ifFalse: [ ^ self ].

	self enqueueTask: (BlTaskAction new action: [
		self phlow
			spawnObject: anAnnouncement object
			withDestination: anAnnouncement spawnDestination ])
]

{ #category : #'api - textual coder view model' }
GtTextualCoderEditorElement >> onPostTextualCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToTextualCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	| anAddOnsPromise |
	
	self textualCoderViewModel hasStyledText
		ifTrue: [ ^ self ].

	"the add-ons will not compute themselves unless we tell them to"
	anAddOnsPromise := self textualCoderViewModel addOns then: [ :theAddOns | self onViewModelReadyToStyle ].
	"this works as a marker to indicate that we are waiting for the promise to finish"
	self enqueueTask: (BlPromiseTask new promise: anAddOnsPromise)
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onPrintRequest: anEvaluationAnnouncement [
	(anEvaluationAnnouncement requesterObject isCoderViewModel: self textualCoderViewModel) 
		ifFalse: [ ^ self ].

	evaluationHighlighter hideResult.
	evaluationPrinter displayResult: anEvaluationAnnouncement evaluationResult.
]

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	
	GtTextualCoderEditorElementRemovedFromSceneGraphSignal emit
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onShowDebuggerRequest: aShowDebuggerAnnouncement [
	| sharedDebugSession anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText |
	evaluationHighlighter hideResult.
	evaluationPrinter hideResult.
	sharedDebugSession := GtSharedDebugSession new session: aShowDebuggerAnnouncement debugSession.
	self showNotification: (GtNotificationDebugSession new debugSession: sharedDebugSession).
	anEvaluatedSource := aShowDebuggerAnnouncement sourceString.
	anEvaluatedInterval := aShowDebuggerAnnouncement sourceInterval.
	theSourceStartInText := (self text finder)
		caseSensitiveSubstring: anEvaluatedSource;
		startAtPosition: anEvaluatedInterval first;
		searchClosest.	
		
	"what did we evaluate?"
	theSourceStartInText isZero ifTrue: [ ^ self ].
	theSourceEndInText := theSourceStartInText + anEvaluatedSource size - 1 min: self text size.
	self text clearAttributes: [ :each | {GtEmbeddedDebuggerAttribute} anySatisfy: [ :cls | each isKindOf: cls ] ].
	self text
		attribute:
			((GtEmbeddedDebuggerAttribute new)
				signaledException: aShowDebuggerAnnouncement exception;
				debugSession: sharedDebugSession)
		from: theSourceEndInText
		to: theSourceEndInText
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onStyleTextRequest: anEvent [
	"onStyleTextRequest: may be sent from a non-UI thread"

	self enqueueTask: (BlTaskAction new action: [ self styleTextAndAfterDo: anEvent afterAction ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onTextModified [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model."

	self textualCoderViewModel
		sourceText: self text
		from: self
		synchronously: true
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onTextModifiedDueToEvent: aTextModifiedEvent [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model. We also receive the event, which can contain the type of change."

	self textualCoderViewModel
		sourceText: self text
		from: self
		synchronously: true
		dueToEvent: aTextModifiedEvent
]

{ #category : #'api - textual coder view model' }
GtTextualCoderEditorElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self onCoderViewModelFocused: self textualCoderViewModel focused.

	"Setting text may change cursor and selection because text editor makes sure
	that they have valid values. That is why we create a snaphot of the editor's state
	which we will restore once new text is set"

	"Related to: https://github.com/feenkcom/gtoolkit/issues/3727"
	"self privateUpdateEditorState: self textualCoderViewModel asEditorState wait."
	
	self asyncPromise  
		promise: self textualCoderViewModel asEditorState.
 
	self editor model:  self textualCoderViewModel.

	shortcuts := self textualCoderViewModel shortcuts copy.
	self editor addEditorShortcuts: shortcuts.
	
	completion strategy: self textualCoderViewModel completionStrategy
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onToolSpawnRequest: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		self phlow
			spawnTool: anAnnouncement tool
			withDestination: anAnnouncement spawnDestination ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onUpdateAddOnsRequest: anAnnouncement [
	self enqueueTask: (BlPromiseTask new promise: self textualCoderViewModel requestUpdateAddOns)
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelCursorsChanged: aCursorsChangedAnnouncement [
	"Is sent when the cursors changes in the View Model.
	May be sent from a non-UI thread"
	
	"if the source of the announcement is myself, do nothing to break the change cycle"
	aCursorsChangedAnnouncement source = self
		ifTrue: [ ^ self ].

	"do nothing if it comes from a different view model"
	aCursorsChangedAnnouncement textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	"since it may be sent from a non-UI process make sure to wrap in the action"
	cursorsUpdater requestUpdate: aCursorsChangedAnnouncement
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelReadyToStyle [
	self styleText
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelSelectionChanged: aSelectionChangedAnnouncement [
	"Is sent when the selection changes in the View Model.
	May be sent from a non-UI thread"

	"if the source of the announcement is myself, do nothing to break the change cycle"

	aSelectionChangedAnnouncement source = self ifTrue: [ ^ self ].

	aSelectionChangedAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	self
		inUIProcessDo: [ self deselecter all deselect.
			self selecter
				withoutCursorUpdate;
				all: aSelectionChangedAnnouncement selection;
				select ]
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelShortcutsChanged [
	"Is sent when the shortcuts change in the View Model.
	May be sent from a non-UI thread"

	"since it may be sent from a non-UI process make sure to wrap in the action"
	self enqueueTask: (BlTaskAction new action: [
		self editor removeEditorShortcuts: shortcuts.
		shortcuts := self textualCoderViewModel shortcuts copy.
		self editor addEditorShortcuts: shortcuts ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelStyledTextChanged: anAnnouncement [
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelStylersChanged [
	self enqueueTask: (BlTaskAction new
		action: [ self styler: self textualCoderViewModel compositeStyler ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelTextAttributesAdded: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement text characters = self text characters
			ifTrue: [
				anAnnouncement coderTextAttributes
					applyOnEditorText: self text
					from: anAnnouncement startPosition
					to: anAnnouncement stopPosition ] ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelTextAttributesRemoved: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement coderTextAttributes removeFromEditorText: self text ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelTextChanged: aGtTextualCoderViewModelTextChanged [

	"When text is modified, the view model starts to recompute addOns"
	self enqueueTask: (BlPromiseTask new promise: self textualCoderViewModel addOns).

	aGtTextualCoderViewModelTextChanged source == self
		ifTrue: [ ^ self hideHighlighters ].
		
	"do nothing if it comes from a different view model"
	aGtTextualCoderViewModelTextChanged textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	aGtTextualCoderViewModelTextChanged isSynchronous
		ifTrue: [ self privateUpdateText: self announcement: aGtTextualCoderViewModelTextChanged ] 
		ifFalse: [ textUpdater requestUpdate: aGtTextualCoderViewModelTextChanged ]
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelTextEditCommandRequest: aGtTextualCoderViewModelTextEditCommandRequest [
	"This is sent by the view model on requests to change the text 
	in the editor by executing a command."
	
	aGtTextualCoderViewModelTextEditCommandRequest textEditCommand
		applyOn: self editor 
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> privateUpdateCursors: anEditorElement announcement: aCursorsChangedAnnouncement [

	"do nothing if it comes from a different view model"
	aCursorsChangedAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	GtTextualCoderEditorElementUpdateCursorsSignal emit.

	self navigator
		withoutResettingDesiredCoordinate;
		removeAll;
		addAll: aCursorsChangedAnnouncement cursors;
		apply
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> privateUpdateEditorState: anEditorState [
	GtTextualCoderEditorElementUpdateStateSignal emit.

	self editor restoreState: anEditorState
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> privateUpdateText: anEditorElement announcement: aGtTextualCoderViewModelTextChanged [
	| textForUpdate |
	"Executed in a UI thread as a result of text being changed in the view model"

	"do nothing if it comes from a different view model"
	aGtTextualCoderViewModelTextChanged textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	GtTextualCoderEditorElementUpdateTextSignal emit.

	"Determine the text that we should use to update the editor."
	textForUpdate := self computeTextForUpdateForTextChangedEvent: aGtTextualCoderViewModelTextChanged.
	
	self text: textForUpdate.
	self hideHighlighters
]

{ #category : #registration }
GtTextualCoderEditorElement >> registerCoderModelAnnouncementsFor: aCoderModel [
	aCoderModel announcer weak
		when: GtCoderAddOnsUpdateRequest
			send: #onUpdateAddOnsRequest:
			to: self;
		when: GtCoderStyleTextRequest send: #onStyleTextRequest: to: self;
		when: GtCoderParseError send: #onCoderParseError: to: self;
		when: GtCoderObjectSpawnRequest
			send: #onObjectSpawnRequest:
			to: self;
		when: GtCoderToolSpawnRequest send: #onToolSpawnRequest: to: self;
		when: GtCoderEvaluationAnnouncement
			send: #onCodeEvaluated:
			to: self;
		when: GtCoderPrintAnnouncement send: #onPrintRequest: to: self;
		when: GtCoderShowDebuggerRequest
			send: #onShowDebuggerRequest:
			to: self
]

{ #category : #registration }
GtTextualCoderEditorElement >> registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel [
	aGtSourceCoderUIModel weak
		when: GtTextualCoderViewModelFocusChanged
			send: #onFocusChangedAnnouncement:
			to: self;
		when: GtTextualCoderViewModelTextChanged
			send: #onViewModelTextChanged:
			to: self;
		when: GtTextualCoderViewModelTextEditCommandRequestAnnouncement
			send: #onViewModelTextEditCommandRequest:
			to: self;
		when: GtTextualCoderViewModelCursorsChanged
			send: #onViewModelCursorsChanged:
			to: self;
		when: GtTextualCoderViewModelSelectionChanged
			send: #onViewModelSelectionChanged:
			to: self;
		when: GtTextualCoderViewModelStylersChanged
			send: #onViewModelStylersChanged
			to: self;
		when: GtTextualCoderViewModelShortcutsChanged
			send: #onViewModelShortcutsChanged
			to: self;
		when: GtTextualCoderViewModelReadyToRestyle
			send: #onViewModelReadyToStyle
			to: self;
		when: GtTextualCoderViewModelTextAttributesAdded
			send: #onViewModelTextAttributesAdded:
			to: self;
		when: GtTextualCoderViewModelTextAttributesRemoved
			send: #onViewModelTextAttributesRemoved:
			to: self;
		when: GtTextualCoderViewModelStyledTextChanged
			send: #onViewModelStyledTextChanged:
			to: self.
]

{ #category : #private }
GtTextualCoderEditorElement >> reportParseError: aString at: anInteger [
	| text position error |
	text := self editor text.

	position := anInteger - 1 max: 0.
	text size < position ifTrue: [ ^ self ].

	text clearAttributesOfClass: GtSourceCoderErrorAttribute.
	error := (aString endsWith: '->')
			ifTrue: [ aString allButLast: 2 ]
			ifFalse: [ aString ].
	text
		attribute: (GtSourceCoderErrorAttribute for: error)
		from: position
		to: position
]

{ #category : #private }
GtTextualCoderEditorElement >> styleText [
	self editor styleText
]

{ #category : #private }
GtTextualCoderEditorElement >> styleTextAndAfterDo: aBlock [
	self editor styleTextAndAfterDo: aBlock
]

{ #category : #'api - textual coder view model' }
GtTextualCoderEditorElement >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"
	
	self registerCoderModelAnnouncementsFor: self textualCoderViewModel coderModel.
	self registerCoderViewModelAnnouncementsFor: self textualCoderViewModel.

	completion install
]

{ #category : #'api - textual coder view model' }
GtTextualCoderEditorElement >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
	
	self textualCoderViewModel unsubscribe: self.
	self textualCoderViewModel coderModel unsubscribe: self.
	
	completion uninstall.
	self editor removeEditorShortcuts: shortcuts
]
