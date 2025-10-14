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
		'textUpdater',
		'addOnsElementFuture'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #private }
GtTextualCoderEditorElement >> addErrorAttribute: errorAttribute at: anInteger [
	| text position |
	text := self editor text.
	position := anInteger - 1 max: 0.
	text size < position ifTrue: [ ^ self ].
	text clearAttributesOfClass: GtSourceCoderErrorAttribute.
	text
		attribute: errorAttribute
		from: position
		to: position.
	self scrollToPosition: (text asString lineNumberCorrespondingToIndex: position)
]

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> attachSpace [
	super attachSpace.
	
	GtTextualCoderEditorElementAttachedSpaceSignal new 
		element: self;
		emit
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
GtTextualCoderEditorElement >> createContextMenu [
	"wait for the addons to be computed"
	<return: #BrMenuItems>

	| aMenu aMenuItemsPromise |
	aMenu := BrMenuItems new.
	aMenu beGroupedElementType.

	aMenuItemsPromise := self textualCoderViewModel addOns
			asyncThen: [ :theAddOns | 
				| theItems theContextMenuAstAddons theMenuItems |
				"extra context menu items that depend on ast and view model state such as selection"
				theContextMenuAstAddons := self textualCoderViewModel
						computeContextMenuAstAddOns.
				theItems := theAddOns contextMenuActions, theContextMenuAstAddons contextMenuActions.
				theItems := theItems reject: [ :e | e title isNil ].
				
				theMenuItems := theItems 
					collect: [ :eachAction | eachAction asBrMenuItemForCoderElement: self ]
					thenReject: #isNil.
				
				self enqueueTask: (BlTaskAction new 
					action: [ 
						aMenu items: theMenuItems ]) ].

	self enqueueTask: (BlPromiseTask new promise: aMenuItemsPromise).

	^ aMenu 
]

{ #category : #initialization }
GtTextualCoderEditorElement >> defaultTextEditorMode [
	^ BrTextEditorEditableCodeMode new
]

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> detachSpace [
	super detachSpace.
	
	GtTextualCoderEditorElementDetachedSpaceSignal new 
		element: self;
		emit
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
		aptitude: BrGlamorousCodeEditorAptitude;
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude menu: [ self createContextMenu ]);
		padding: BlInsets empty;
		hMatchParent;
		vFitContentLimited.

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

	addOnsElementFuture := (BrAsyncElementFuture on: self)
		executionConfiguration: (GtSingleCoderViewModel methodAddOnsExecutionConfiguration);
		whenSuccess: [ :anEditorElement :theAddOns |
			self textualCoderViewModel onAddOnsChanged: theAddOns ];
		whenError: [ :anEditorElement :anError | 
			self onAddOnsError: anError ].

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
		when: BrTextEditorHistoryChangedEvent
		do: [ :anEvent | 
			textualCoderViewModel
				ifNotNil: [ textualCoderViewModel history: self editor history copy ] ].

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
		do: [ :anEvent | self onTextStyled: anEvent ]
]

{ #category : #initialization }
GtTextualCoderEditorElement >> onAddOnsError: anError [
	anError emit.
	NonInteractiveTranscript stderr
		show: '[GtTextualCoderEditorElement>>#onAddOnsError:] ';
		show: anError;
		newLine
]

{ #category : #'hooks - children' }
GtTextualCoderEditorElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	
	GtTextualCoderEditorElementAddedToSceneGraphSignal new 
		element: self;
		emit
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
		isUndefinedOrCoderViewModel: self textualCoderViewModel) ifFalse: [ ^ self ].	"A parse error can be notifying from a non-UI thread"
	self
		enqueueTask: [ aGtCoderParseError isUndeclaredError
				ifTrue: [ self reportUndeclaredError: aGtCoderParseError ]
				ifFalse: [ self
						reportParseError: aGtCoderParseError errorMessage
						at: aGtCoderParseError location ] ] asBlTask
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
	
	self textualCoderViewModel requestUpdateAddOns
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
	
	GtTextualCoderEditorElementRemovedFromSceneGraphSignal new 
		element: self;
		emit
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onScrollToCharacterPositionAnnouncement: anAnnouncement [
	BrEditorSearchTextScroller new
		editorElement: self;
		lineIndex: anAnnouncement lineIndex;
		characterStartPosition: anAnnouncement characterPosition;
		characterStopPosition: anAnnouncement characterPosition;
		scroll
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onSearchTextGetTextAndVisibleTextAnnouncement: anAnnouncement [
	self assertUIProcess.
	anAnnouncement consumed ifTrue: [ ^ self ].
	anAnnouncement consumed: true.
	
	anAnnouncement text: self text.
	anAnnouncement visibleText: self visibleText
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onSearchTextUpdateTextAnnouncement: anAnnouncement [
	| aResult |
	self assertUIProcess.
	anAnnouncement consumed ifTrue: [ ^ self ].
	anAnnouncement consumed: true.

	aResult := BrEditorSearchTextUpdater new
		editorModel: self editor;
		styledText: anAnnouncement styledText;
		update.
		
	anAnnouncement isUpdated: aResult
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

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onTextStyled: anEvent [
	"An underlying editor styled the text"
	
	self textualCoderViewModel styledText: anEvent styledText
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
	self privateUpdateEditorState: self textualCoderViewModel asEditorState.
 
	self editor model:  self textualCoderViewModel.

	shortcuts := self textualCoderViewModel shortcuts copy.
	self editor addEditorShortcuts: shortcuts.
	
	completion strategy: self textualCoderViewModel completionStrategy.
	
	self textualCoderViewModel compositeStyler ifNotNil: [ :aStyler | 
		self styler: aStyler ]
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onToolSpawnRequest: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement requesterObject = self textualCoderViewModel ifTrue: [
			self phlow
				spawnTool: anAnnouncement tool
				withDestination: anAnnouncement spawnDestination ] ])
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
	self enqueueTask: (BlTaskAction new action: [ self styleText ])
]

{ #category : #registration }
GtTextualCoderEditorElement >> onViewModelRecomputeAddOns: aRecomputeAddOnRequest [
	aRecomputeAddOnRequest coderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	addOnsElementFuture future: self textualCoderViewModel addOnsFuture
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
				in: [ :aSelecter | 
					aSelectionChangedAnnouncement shouldUpdateCursor 
						ifFalse: [ aSelecter withoutCursorUpdate ] ];
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
	"Text changed in a view model and should be synchronised on the UI side.
	There can be multiple sources of the text change:
	 - an editor element itself
	 - other sources that changed text through coder model api.
	 
	 When the source is a text editor element (`self`) we don't reset the text in the editor.
	 If an announcement comes from a different view model, we skip it."


	"Do nothing if it comes from a different view model"
	aGtTextualCoderViewModelTextChanged textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	aGtTextualCoderViewModelTextChanged source == self
		ifTrue: [ ^ self hideHighlighters ].
	
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

	GtTextualCoderEditorElementUpdateCursorsSignal new 
		element: self;
		emit.

	self navigator
		withoutResettingDesiredCoordinate;
		removeAll;
		addAll: aCursorsChangedAnnouncement cursors;
		apply
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> privateUpdateEditorState: anEditorState [
	GtTextualCoderEditorElementUpdateStateSignal new 
		element: self;
		emit.

	self editor restoreState: anEditorState
]

{ #category : #'private - updating' }
GtTextualCoderEditorElement >> privateUpdateText: anEditorElement announcement: aGtTextualCoderViewModelTextChanged [
	| textForUpdate |
	"Executed in a UI thread as a result of text being changed in the view model"

	"do nothing if it comes from a different view model"
	aGtTextualCoderViewModelTextChanged textualCoderViewModel == self textualCoderViewModel
		ifFalse: [ ^ self ].

	GtTextualCoderEditorElementUpdateTextSignal new 
		element: self;
		emit.

	"Determine the text that we should use to update the editor."
	textForUpdate := self computeTextForUpdateForTextChangedEvent: aGtTextualCoderViewModelTextChanged.
	
	self text: textForUpdate.
	self hideHighlighters.
]

{ #category : #registration }
GtTextualCoderEditorElement >> registerCoderModelAnnouncementsFor: aCoderModel [
	aCoderModel announcer weak
		when: GtCoderStyleTextRequest send: #onStyleTextRequest: to: self;
		when: GtCoderParseError send: #onCoderParseError: to: self;
		when: GtCoderObjectSpawnRequest
			send: #onObjectSpawnRequest:
			to: self;
		when: GtCoderToolSpawnRequest send: #onToolSpawnRequest: to: self;
		when: GtCoderEvaluationAnnouncement
			send: #onCodeEvaluated:
			to: self;
		when: GtCoderPrintAnnouncement send: #onPrintRequest: to: self
]

{ #category : #registration }
GtTextualCoderEditorElement >> registerCoderViewModelAnnouncementsFor: aGtSourceCoderUIModel [
	aGtSourceCoderUIModel weak
		when: GtCoderViewModelRecomputeAddOnRequest
			send: #onViewModelRecomputeAddOns:
			to: self;
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
			to: self;
		when: GtTextualCoderViewModelScrollToCharacterPositionAnnouncement
			send: #onScrollToCharacterPositionAnnouncement:
			to: self;
		when: GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement
			send: #onSearchTextGetTextAndVisibleTextAnnouncement:
			to: self;
		when: GtTextualCoderViewModelSearchTextUpdateTextAnnouncement
			send: #onSearchTextUpdateTextAnnouncement:
			to: self
]

{ #category : #private }
GtTextualCoderEditorElement >> reportParseError: aString at: anInteger [
	| error |
	error := (aString endsWith: '->')
			ifTrue: [ aString allButLast: 2 ]
			ifFalse: [ aString ].
	self addErrorAttribute: (GtSourceCoderErrorAttribute for: error) at: anInteger
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> reportUndeclaredError: aGtCoderParseError [
	| rbNode interval gtNode ast errorAttribute |
	rbNode := aGtCoderParseError node.
	interval := rbNode sourceInterval.
	ast := GtPharoParser
			parse: rbNode methodNode source
			startingAt: (rbNode methodNode isDoIt
					ifTrue: [ GtPharoParser startingStateForDoItMethod ]
					ifFalse: [ GtPharoParser startingStateForMethod ]).
	gtNode := ast nodeForInterval: interval.
	errorAttribute := GtUndeclaredVariableAdvice new
			errorAttribute: gtNode
			coderModel: aGtCoderParseError coder.
	self addErrorAttribute: errorAttribute at: aGtCoderParseError location
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

{ #category : #'editor - accessing' }
GtTextualCoderEditorElement >> text: aBlText [
	(self text equalsIgnoringAttributes: aBlText)
		ifTrue: [ ^ self dataSource history disableDuring: [ super text: aBlText ] ].
	^ super text: aBlText
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
