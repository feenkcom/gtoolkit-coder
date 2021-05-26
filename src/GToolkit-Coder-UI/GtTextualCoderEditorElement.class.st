Class {
	#name : #GtTextualCoderEditorElement,
	#superclass : #BrEditor,
	#traits : 'TBlAssertUIProcess + TGtWithTextualCoderViewModel',
	#classTraits : 'TBlAssertUIProcess classTrait + TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'completion',
		'evaluationHighlighter',
		'evaluationPrinter',
		'shortcuts'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #'api - textual coder view model' }
GtTextualCoderEditorElement >> coderUIModel: aTextualCoderViewModel [
	self textualCoderViewModel: aTextualCoderViewModel
]

{ #category : #'instance creation' }
GtTextualCoderEditorElement >> createContextMenuContent [
	"wait for the addons to be computed"
	| theContextMenu |
	
	theContextMenu := GtCoderContextMenuContent new
		editorElement: self.	
	
	self textualCoderViewModel addOnsAsyncDo: [ :theAddOns |
		| theItems theContextMenuAstAddons |
		
		"extra context menu items that depend on ast and view model state such as selection"
		theContextMenuAstAddons := self textualCoderViewModel computeContextMenuAstAddOns.
		
		theItems := theAddOns contextMenuActions, theAddOns mainActions, theContextMenuAstAddons contextMenuActions.
		theItems := theItems reject: [ :e | e title isNil ]. 
		
		theContextMenu enqueueTask: (BlTaskAction new action: [ theContextMenu items: theItems ]) ].

	^ theContextMenu
]

{ #category : #private }
GtTextualCoderEditorElement >> hideHighlighters [
	self text clearAttributes: [ :eachAttribute | 
		eachAttribute isKindOf: GtSourceCoderErrorAttribute ].
	evaluationHighlighter hideResultSynchronously.
	evaluationPrinter hideResultSynchronously.
]

{ #category : #private }
GtTextualCoderEditorElement >> highlightPCRangeForInterval: aSelectionInterval [
	self textualCoderViewModel isModified
		ifTrue: [ ^ self ].
	self text
		clearAttributes: [ :each | each class = BlTextDecorationAttribute ].
	(self text from: aSelectionInterval first to: aSelectionInterval last)
		underlineDo: [ :anAttribute | 
			anAttribute
				color: self theme status errorBackgroundColor;
				thickness: 1.5;
				beNotOverwritableByStyler ]
]

{ #category : #initialization }
GtTextualCoderEditorElement >> initialize [
	super initialize.
	
	self
		aptitude: BrGlamorousCodeEditorAptitude + (BrGlamorousWithContextMenuAptitude content: [ self createContextMenuContent ]);
		padding: BlInsets empty;
		hMatchParent;
		vFitContent.

	self editor
		beEditableCode;
		disableStyleTextWhenModified.

	shortcuts := #().
	completion := GtCompletionController on: self.

	evaluationHighlighter := GtSourceCoderEvaluationHighlighter new editorElement: self.
	evaluationPrinter := GtSourceCoderEvaluationPrinter new editorElement: self.

	self initializeListeners
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
		do: [ :anEvent | self onTextModified ].

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

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onCodeEvaluated: anEvaluationAnnouncement [
	evaluationHighlighter displayResult: anEvaluationAnnouncement evaluationResult.
	evaluationPrinter hideResult
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onCoderParseError: aGtCoderParseError [
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
GtTextualCoderEditorElement >> onContextPCRangeChanged: aContextPCRangeChangedAnnouncement [
	| selectionInterval |
	
	selectionInterval := aContextPCRangeChangedAnnouncement pcRange.
	self highlightPCRangeForInterval: selectionInterval
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onCursorsChanged: aCursorsChangedAnnouncement [
	"Is sent when the cursors change in the View Model.
	May be sent from a non-UI thread"
	
	"if the source of the announcement is myself, do nothing to break the change cycle"
	aCursorsChangedAnnouncement source = self
		ifTrue: [ ^ self ].

	"since it may be sent from a non-UI process make sure to wrap in the action"
	self enqueueTask: (BlTaskAction new action: [
		self navigator
			withoutResettingDesiredCoordinate;
			removeAll;
			addAll: aCursorsChangedAnnouncement cursors;
			apply ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onFocusChangedAnnouncement: anAnnouncement [
	self assertUIProcess.

	anAnnouncement source == self
		ifTrue: [ ^ self ].

	anAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	self onCoderViewModelFocused: anAnnouncement focused
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onObjectSpawnRequest: anAnnouncement [
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
	
	self textualCoderViewModel hasStyledText
		ifTrue: [ ^ self ].
	
	"the add-ons will not compute themselves unless we tell them to"
	self textualCoderViewModel addOnsAsyncDo: [ :theAddOns | self onViewModelReadyToStyle ]
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onPrintRequest: anEvaluationAnnouncement [
	evaluationHighlighter hideResult.
	evaluationPrinter displayResult: anEvaluationAnnouncement evaluationResult.
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onShowDebuggerRequest: aShowDebuggerAnnouncement [
	| sharedDebugSession anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText |
	
	evaluationHighlighter hideResult.
	evaluationPrinter hideResult.
	
	sharedDebugSession := GtSharedDebugSession new
		session: aShowDebuggerAnnouncement debugSession.
	
	self showNotification: (GtNotificationDebugSession new debugSession: sharedDebugSession).
	
	anEvaluatedSource := aShowDebuggerAnnouncement sourceString.
	anEvaluatedInterval := aShowDebuggerAnnouncement sourceInterval.
	
	theSourceStartInText := self text finder
		caseSensitiveSubstring: anEvaluatedSource;
		startAtPosition: anEvaluatedInterval first;
		searchClosest.
	
	"what did we evaluate?"
	theSourceStartInText isZero
		ifTrue: [ ^ self ].

	theSourceEndInText := (theSourceStartInText + anEvaluatedSource size - 1) min: self text size.
	
	self text
		clearAttributes: [ :each | 
			{ GtEmbeddedDebuggerAttribute } anySatisfy: [ :cls | each isKindOf: cls ] ].

	(self text from: theSourceStartInText to: theSourceEndInText)
		attribute: (GtEmbeddedDebuggerAttribute new 
			signaledException: aShowDebuggerAnnouncement exception;
			debugSession: sharedDebugSession)
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onStyleTextRequest: anEvent [
	"onStyleTextRequest: may be sent from a non-UI thread"

	self enqueueTask: (BlTaskAction new action: [ self styleTextAndAfterDo: anEvent afterAction ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onStylersUpdated: anAnnouncement [
	
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onTextModified [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model."

	self textualCoderViewModel
		sourceText: self text
		from: self
		synchronously: true
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
	self editor restoreState: self textualCoderViewModel asEditorState.

	self editor model: self textualCoderViewModel.
	
	shortcuts := self textualCoderViewModel shortcuts copy.
	self editor addEditorShortcuts: shortcuts.
	
	completion strategy: self textualCoderViewModel coderModel completionStrategy
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
	
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelCursorsChanged: aCursorsChangedAnnouncement [
	"Is sent when the cursors changes in the View Model.
	May be sent from a non-UI thread"
	
	"if the source of the announcement is myself, do nothing to break the change cycle"
	aCursorsChangedAnnouncement source = self
		ifTrue: [ ^ self ].

	aCursorsChangedAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	"since it may be sent from a non-UI process make sure to wrap in the action"
	self enqueueTask: (BlTaskAction new action: [
		self navigator
			withoutResettingDesiredCoordinate;
			removeAll;
			addAll: aCursorsChangedAnnouncement cursors;
			apply ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelReadyToStyle [
	self enqueueTask: (BlTaskAction new action: [ self editor styleText ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelSelectionChanged: aSelectionChangedAnnouncement [
	"Is sent when the selection changes in the View Model.
	May be sent from a non-UI thread"
	
	"if the source of the announcement is myself, do nothing to break the change cycle"
	aSelectionChangedAnnouncement source = self
		ifTrue: [ ^ self ].
		
	aSelectionChangedAnnouncement source == self textualCoderViewModel
		ifFalse: [ ^ self ].

	"since it may be sent from a non-UI process make sure to wrap in the action"
	self enqueueTask: (BlTaskAction new action: [
		self deselecter all deselect.
		self selecter
			withoutCursorUpdate;
			all: aSelectionChangedAnnouncement selection;
			select ])
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
		anAnnouncement coderTextAttributes
			applyOnEditorText: self text
			from: anAnnouncement startPosition
			to: anAnnouncement stopPosition ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelTextAttributesRemoved: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		anAnnouncement coderTextAttributes removeFromEditorText: self text ])
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElement >> onViewModelTextChanged: aGtTextualCoderViewModelTextChanged [

	aGtTextualCoderViewModelTextChanged source == self
		ifTrue: [ ^ self hideHighlighters ].

	aGtTextualCoderViewModelTextChanged isSynchronous
		ifTrue: [ 
			self text: aGtTextualCoderViewModelTextChanged text copy.
			self hideHighlighters ] 
		ifFalse: [ self enqueueTask: (BlTaskAction new action: [ 
			self text: aGtTextualCoderViewModelTextChanged text copy.
			self hideHighlighters ]) ]
]

{ #category : #registration }
GtTextualCoderEditorElement >> registerCoderModelAnnouncementsFor: aCoderModel [
	aCoderModel announcer weak
		when: GtCoderAddOnsUpdateRequest
			send: #onUpdateAddOnsRequest:
			to: self;
		when: GtCoderStylerChanged send: #onStylersUpdated: to: self;
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
		when: GtMethodCoderContextPCRangeChanged
			send: #onContextPCRangeChanged:
			to: self;
		when: GtSourceCoderFocusChanged
			send: #onFocusChangedAnnouncement:
			to: self;

		when: GtTextualCoderViewModelTextChanged
			send: #onViewModelTextChanged:
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
	| text position |

	text := self editor text.
	
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	
	text clearAttributesOfClass: GtSourceCoderErrorAttribute.
	text 
		attribute: (GtSourceCoderErrorAttribute for: aString)
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
