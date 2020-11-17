Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #BrEditor,
	#instVars : [
		'sourceCoderUIModel',
		'interactions',
		'completion'
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

{ #category : #initialization }
GtSourceCoderEditorElement >> initialize [
	super initialize.
	
	self
		look: BrGlamorousCodeEditorLook + (BrGlamorousWithContextMenuLook content: [ self createContextMenuContent ]);
		padding: (BlInsets empty);
		hMatchParent;
		vFitContent.

	self editor
		when: BrTextEditorModifiedEvent
		do: [ self sourceChanged ];
		beEditableCode.

	interactions := #().
	completion := nil.
	
	self initializeListeners
]

{ #category : #initialization }
GtSourceCoderEditorElement >> initializeListeners [
	self when: GtCoderSaveUIModelWish do: [ :anEvent | self onSaveSourceCoderUIModel: anEvent coderUIModel ].
	self when: BlFocusInEvent do: [ :anEvent | self sourceCoderUIModel focused: true ].
	self when: BlFocusOutEvent do: [ :anEvent | self sourceCoderUIModel focused: false ].
]

{ #category : #'instance creation' }
GtSourceCoderEditorElement >> newEditorMemento [
	^ BrTextEditorCompositeMemento new text selection cursors history
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onCoderParseError: aGtCoderParseError [
	self 
		reportParseError: aGtCoderParseError errorMessage 
		at: aGtCoderParseError location
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onSaveSourceCoderUIModel: aGtSourceCoderUIModel [
	aGtSourceCoderUIModel
		editorState: (self editor saveState: self newEditorMemento).
	aGtSourceCoderUIModel focused: self hasFocus
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onSourceCodeChanged: aGtCoderSourceCodeChanged [
	aGtCoderSourceCodeChanged isSynchronous
		ifTrue: [ self updateSourceCode ] 
		ifFalse: [ self enqueueTask: (BlTaskAction new action: [ self updateSourceCode ]) ]
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onStyleTextRequest: anEvent [
	self styleTextAndAfterDo: anEvent afterAction
]

{ #category : #'private - event handling' }
GtSourceCoderEditorElement >> onStylersUpdated: anAnnouncement [		
	self styler: (anAnnouncement coder newSourceStylerFrom: self)
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
GtSourceCoderEditorElement >> sourceChanged [
	"Is sent when the current source code changes due to user input in the editor"

	sourceCoderUIModel ifNotNil: [ :aSourceCoderUIModel | aSourceCoderUIModel coder sourceChanged ]
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
		when: GtCoderStylerChanged send: #onStylersUpdated: to: self;
		when: GtCoderStyleTextRequest send: #onStyleTextRequest: to: self;
		when: GtCoderSourceCodeChanged send: #onSourceCodeChanged: to: self;
		when: GtCoderParseError send: #onCoderParseError: to: self.

	aGtSourceCoderUIModel focused
		ifTrue: [ self requestFocus ].
		
	aGtSourceCoderUIModel coder updateAddOns
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
	(self text = sourceCoderUIModel coder sourceText)
		ifFalse: [ self text: sourceCoderUIModel coder sourceText ]
]
