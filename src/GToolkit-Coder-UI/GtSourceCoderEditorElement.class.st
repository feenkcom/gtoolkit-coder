Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #BrEditor,
	#instVars : [
		'sourceCoderUIModel',
		'interactions',
		'completion',
		'evaluationHighlighter'
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
GtSourceCoderEditorElement >> highlightEvaluatedCode: anEvaluationResult [
	| anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText |
	
	anEvaluatedSource := anEvaluationResult sourceString.
	anEvaluatedInterval := anEvaluationResult sourceInterval.
	
	theSourceStartInText := self text finder
		caseSensitiveSubstring: anEvaluatedSource;
		startAtPosition: anEvaluatedInterval first;
		searchClosest.

	"what did we evaluate?"
	theSourceStartInText isZero
		ifTrue: [ ^ self ].

	theSourceEndInText := theSourceStartInText + anEvaluatedSource size - 1.
	
	anEvaluationResult isSuccess
		ifTrue: [
			(self text 
				from: theSourceStartInText
				to: theSourceEndInText) underlineDo: [ :anUnderline | 
					anUnderline
						color: (Color fromHexString: #'90CAF9');
						thickness: 1 ]
		].


	"self text
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new 
				result: value;
				coder: self ""Pass the coder to get the spawn destination"")}
		from: interval last
		to: interval last.
	aBoolean
		ifTrue: [ aBlText
				attributes: {(GtCoderPrintStringAttribute forString: value printString)}
				from: interval last
				to: interval last ].
	aBlText
		attributes:
			{(GtPlaygroundEvaluatedCodeHighlightedAttribute new
				paint: (Color fromHexString: #'90CAF9'))}
		from: interval first
		to: interval last"
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
	evaluationHighlighter := GtSourceCoderEditorElementEvaluationHighlighter new editorElement: self.

	self initializeListeners
]

{ #category : #initialization }
GtSourceCoderEditorElement >> initializeListeners [
	self when: GtCoderSaveUIModelWish do: [ :anEvent | self onSaveSourceCoderUIModel: anEvent coderUIModel ].
	self when: BlFocusInEvent do: [ :anEvent | self sourceCoderUIModel focused: true ].
	self when: BlFocusOutEvent do: [ :anEvent | self sourceCoderUIModel focused: false ].
	
	self editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self onTextModified: anEvent ]
]

{ #category : #'instance creation' }
GtSourceCoderEditorElement >> newEditorMemento [
	^ BrTextEditorCompositeMemento new text selection cursors history
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onCodeEvaluated: anEvaluationAnnouncement [
	evaluationHighlighter highlight: anEvaluationAnnouncement evaluationResult
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
GtSourceCoderEditorElement >> onSaveSourceCoderUIModel: aGtSourceCoderUIModel [
	self saveCoderUIModel: aGtSourceCoderUIModel
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onShowDebuggerRequest: aShowDebuggerAnnouncement [
	| sharedDebugSession anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText |
	
	evaluationHighlighter highlight: nil.
	
	sharedDebugSession := GtSharedDebugSession new
		session: aShowDebuggerAnnouncement debugSession.
	
	self showNotification: (GtNotificationDebugSessionEvent new debugSession: sharedDebugSession).
	
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
		ifTrue: [ self updateSourceCode ] 
		ifFalse: [ self enqueueTask: (BlTaskAction new action: [ self updateSourceCode ]) ].
		
	evaluationHighlighter highlight: nil
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onStyleTextRequest: anEvent [
	self styleTextAndAfterDo: anEvent afterAction
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onStylersUpdated: anAnnouncement [
	self styler: (anAnnouncement coder newSourceStylerFrom: self)
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onTextModified: aBrTextEditorModifiedEvent [
	"Is sent when the text changes in the editor. Here we should synchronise the UI and the model."

	sourceCoderUIModel ifNotNil: [ :aSourceCoderUIModel |
		aSourceCoderUIModel coder currentSourceTextSynchronously: self text ]
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

{ #category : #accessing }
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
		ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
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

	aGtSourceCoderUIModel announcer weak
		when: GtCoderEvaluationAnnouncement send: #onCodeEvaluated: to: self;
		when: GtCoderAddOnsUpdateRequest send: #onUpdateAddOnsRequest: to: self;
		when: GtCoderStylerChanged send: #onStylersUpdated: to: self;
		when: GtCoderStyleTextRequest send: #onStyleTextRequest: to: self;
		when: GtCoderSourceCodeChanged send: #onSourceCodeChanged: to: self;
		when: GtCoderParseError send: #onCoderParseError: to: self;
		when: GtCoderObjectSpawnRequest send: #onObjectSpawnRequest: to: self;
		when: GtCoderToolSpawnRequest send: #onToolSpawnRequest: to: self;
		when: GtCoderShowDebuggerRequest send: #onShowDebuggerRequest: to: self.

	aGtSourceCoderUIModel focused
		ifTrue: [ self requestFocus ].

	aGtSourceCoderUIModel coder updateAddOns.
	evaluationHighlighter highlight: aGtSourceCoderUIModel evaluationResult
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
	
	aNewSourceCode clearAttributes: [ :eachAttribute | eachAttribute isKindOf: GtSourceCoderErrorAttribute ].
	self text: aNewSourceCode.
	evaluationHighlighter highlightSynchronously: nil
]
