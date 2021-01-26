Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #BrEditor,
	#instVars : [
		'sourceCoderUIModel',
		'interactions',
		'completion',
		'evaluationHighlighter',
		'evaluationPrinter'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'instance creation' }
GtSourceCoderEditorElement >> createContextMenuContent [
	^ sourceCoderUIModel
		ifNil: [ BlElement new ]
		ifNotNil: [
			sourceCoderUIModel coder updateContextMenuAddOnsFrom: self.
			GtCoderContextMenuContent new
				editorElement: self;
				items: (sourceCoderUIModel coder contextMenuActions reject: [ :e | e title isNil ]), (sourceCoderUIModel coder mainActions reject: [ :e | e title isNil ]);
				yourself ]
]

{ #category : #private }
GtSourceCoderEditorElement >> hideHighlighters [
	self text clearAttributes: [ :eachAttribute | 
		eachAttribute isKindOf: GtSourceCoderErrorAttribute ].
	evaluationHighlighter hideResultSynchronously.
	evaluationPrinter hideResultSynchronously.
]

{ #category : #initialization }
GtSourceCoderEditorElement >> initialize [
	super initialize.
	
	self
		look: BrGlamorousCodeEditorLook + (BrGlamorousWithContextMenuLook content: [ self createContextMenuContent ]);
		padding: BlInsets empty;
		hMatchParent;
		vFitContent.

	self editor
		beEditableCode.

	interactions := #().
	completion := nil.

	evaluationHighlighter := GtSourceCoderEvaluationHighlighter new editorElement: self.
	evaluationPrinter := GtSourceCoderEvaluationPrinter new editorElement: self.

	self initializeListeners
]

{ #category : #initialization }
GtSourceCoderEditorElement >> initializeListeners [
	self when: GtCoderSaveUIModelWish do: [ :anEvent | self onSaveSourceCoderUIModel: anEvent coderUIModel ].
	self when: BlFocusInEvent do: [ :anEvent | self sourceCoderUIModel focused: true ].
	self when: BlFocusOutEvent do: [ :anEvent |
		"when elements are removed from the scene graph due to tab switching or scrolling they lose focus.
		We are only interested when focus is lost explicitly via user interaction"
		anEvent isDueToRemoval
			ifFalse: [ self sourceCoderUIModel focused: false ] ].

	self editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self onTextModified ].

	self editor
		when: BrTextEditorCursorChangedEvent 
		do: [ :anEvent | self maySaveCoderUIModel ].

	self editor
		when: BrTextEditorSelectionChangedEvent 
		do: [ :anEvent | self maySaveCoderUIModel ]
]

{ #category : #private }
GtSourceCoderEditorElement >> maySaveCoderUIModel [
	sourceCoderUIModel ifNotNil: [ :aCoderUIModel | self saveCoderUIModel: aCoderUIModel ]
]

{ #category : #'instance creation' }
GtSourceCoderEditorElement >> newEditorMemento [
	^ BrTextEditorCompositeMemento new text selection cursors history
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onCodeEvaluated: anEvaluationAnnouncement [
	evaluationHighlighter displayResult: anEvaluationAnnouncement evaluationResult.
	evaluationPrinter hideResult
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onCoderParseError: aGtCoderParseError [
	self 
		reportParseError: aGtCoderParseError errorMessage 
		at: aGtCoderParseError location
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onObjectSpawnRequest: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		self phlow
			spawnObject: anAnnouncement object
			withDestination: anAnnouncement spawnDestination ])
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onPrintRequest: anEvaluationAnnouncement [
	evaluationHighlighter hideResult.
	evaluationPrinter displayResult: anEvaluationAnnouncement evaluationResult.
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onSaveSourceCoderUIModel: aGtSourceCoderUIModel [
	self saveCoderUIModel: aGtSourceCoderUIModel
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onShowDebuggerRequest: aShowDebuggerAnnouncement [
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
GtSourceCoderEditorElement >> onSourceCodeChanged: aGtCoderSourceCodeChanged [
	aGtCoderSourceCodeChanged isSynchronous
		ifTrue: [ 
			self updateSourceCode.
			self hideHighlighters ] 
		ifFalse: [ self enqueueTask: (BlTaskAction new action: [ 
			self updateSourceCode.
			self hideHighlighters ]) ].
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onStyleTextRequest: anEvent [
	self styleTextAndAfterDo: anEvent afterAction
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onStylersUpdated: anAnnouncement [
	self enqueueTask: (BlTaskAction new
		action: [ self styler: (anAnnouncement coder newSourceStylerFrom: self) ])
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onTextModified [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model."

	sourceCoderUIModel ifNotNil: [ :aSourceCoderUIModel |
		aSourceCoderUIModel coder currentSourceTextSynchronously: self text ].
	
	self maySaveCoderUIModel
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onToolSpawnRequest: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [
		self phlow
			spawnTool: anAnnouncement tool
			withDestination: anAnnouncement spawnDestination ])
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onUpdateAddOnsRequest: anAnnouncement [
	anAnnouncement coder updateAddOns
]

{ #category : #private }
GtSourceCoderEditorElement >> reportParseError: aString at: anInteger [
	| text position |
	text := self editor text.
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	(text from: position to: position)
		attributes: {(GtSourceCoderErrorAttribute for: aString , ' ->')}.
	self editor moveCursorTo: position
]

{ #category : #private }
GtSourceCoderEditorElement >> saveCoderUIModel: aGtSourceCoderUIModel [
	aGtSourceCoderUIModel
		editorState: (self editor saveState: self newEditorMemento).
	aGtSourceCoderUIModel focused: self hasFocus.
	aGtSourceCoderUIModel evaluationResult: evaluationHighlighter evaluationResult
]

{ #category : #accessing }
GtSourceCoderEditorElement >> sourceCoderUIModel [
	^ sourceCoderUIModel
]

{ #category : #accessing }
GtSourceCoderEditorElement >> sourceCoderUIModel: aGtSourceCoderUIModel [
	sourceCoderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder coder announcer unsubscribe: self ].
	completion
		ifNotNil: [ :aPreviousCompletion | aPreviousCompletion uninstall ].
	self editor removeEditorShortcuts: interactions.

	sourceCoderUIModel := aGtSourceCoderUIModel.
	aGtSourceCoderUIModel editorState
		ifNil: [ aGtSourceCoderUIModel editorState: self newEditorMemento ].
	self editor restoreState: aGtSourceCoderUIModel editorState.
	interactions := aGtSourceCoderUIModel coder shortcuts copy.
	self text: aGtSourceCoderUIModel coder sourceText.
	self editor model: aGtSourceCoderUIModel coder.
	self editor addEditorShortcuts: interactions.
	completion := GtCompletionController
		on: self
		strategy: aGtSourceCoderUIModel coder completionStrategy.
	completion install.
	(aGtSourceCoderUIModel coder newSourceStylerFrom: self)
		ifNotNil: [ :styler | self styler: styler ].

	aGtSourceCoderUIModel coder announcer weak
		when: GtCoderAddOnsUpdateRequest
			send: #onUpdateAddOnsRequest:
			to: self;
		when: GtCoderStylerChanged
			send: #onStylersUpdated:
			to: self;
		when: GtCoderStyleTextRequest
			send: #onStyleTextRequest:
			to: self;
		when: GtCoderSourceCodeChanged
			send: #onSourceCodeChanged:
			to: self;
		when: GtCoderParseError
			send: #onCoderParseError:
			to: self;
		when: GtCoderObjectSpawnRequest
			send: #onObjectSpawnRequest:
			to: self;
		when: GtCoderToolSpawnRequest
			send: #onToolSpawnRequest:
			to: self;
		when: GtCoderEvaluationAnnouncement
			send: #onCodeEvaluated:
			to: self;
		when: GtCoderPrintAnnouncement
			send: #onPrintRequest:
			to: self;
		when: GtCoderShowDebuggerRequest
			send: #onShowDebuggerRequest:
			to: self.

	aGtSourceCoderUIModel focused
		ifTrue: [ self requestFocus ].
	aGtSourceCoderUIModel coder updateAddOns.

	aGtSourceCoderUIModel evaluationResult
		ifNil: [ evaluationHighlighter hideResult ]
		ifNotNil: [ :aResult | evaluationHighlighter displayResult: aResult ].
]

{ #category : #private }
GtSourceCoderEditorElement >> styleText [
	self styleTextAndAfterDo: [  ]
]

{ #category : #private }
GtSourceCoderEditorElement >> styleTextAndAfterDo: aBlock [
	self editor styleTextAndAfterDo: aBlock
]

{ #category : #private }
GtSourceCoderEditorElement >> updateSourceCode [
	| aNewSourceCode |
	
	aNewSourceCode := sourceCoderUIModel coder sourceText copy.
	
	(self text generation = aNewSourceCode generation)
		ifTrue: [ ^ self ].
		
	(self text characters = aNewSourceCode characters)
		ifTrue: [ ^ self ].
	
	self text: aNewSourceCode.
	

]
