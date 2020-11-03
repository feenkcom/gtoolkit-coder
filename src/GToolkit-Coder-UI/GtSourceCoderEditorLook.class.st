Class {
	#name : #GtSourceCoderEditorLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'sourceCoderUIModel',
		'editorElement',
		'interactions',
		'completion',
		'actions'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> createContextMenuContent [
	^ sourceCoderUIModel
		ifNil: [ BlElement new ]
		ifNotNil: [
			sourceCoderUIModel coder updateContextMenuAddOnsFrom: self editorElement.
			GtCoderContextMenuContent new
				editorElement: self editorElement;
				items: (sourceCoderUIModel coder contextMenuActions reject: [ :e | e title isNil ]), (sourceCoderUIModel coder mainActions reject: [ :e | e title isNil ]);
				yourself ]
]

{ #category : #accessing }
GtSourceCoderEditorLook >> editorElement [
	<return: #BrEditor>

	^ editorElement
]

{ #category : #initialization }
GtSourceCoderEditorLook >> initialize [
	super initialize.
	
	editorElement := self newEditorElement.
	editorElement editor
		when: BrTextEditorModifiedEvent
		do: [ self sourceChanged ];
		beEditableCode.
		
	actions := self newActionsElement editor: editorElement.
		
	interactions := #().
	completion := nil.
	
	self addChangeAddChildAs: #(content editor) with: [ editorElement ].
	self addChangeAddChildAs: #(content actions) with: [ actions ].
	
	self add: (BrLayoutResizerLook new inherit: editorElement)
]

{ #category : #initialization }
GtSourceCoderEditorLook >> initializeListeners [
	super initializeListeners.
	
	self when: GtCoderSaveUIModelWish do: [ :anEvent | self onSaveSourceCoderUIModel: anEvent coderUIModel ]
]

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> newActionsElement [
	^ GtSourceCoderActionsElement new
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> newEditorElement [
	^ BrEditor new
		look: BrGlamorousCodeEditorLook + (BrGlamorousWithContextMenuLook content: [ self createContextMenuContent ]);
		padding: (BlInsets all: 1);
		hMatchParent;
		vFitContent
]

{ #category : #hooks }
GtSourceCoderEditorLook >> onCoderChanged: aGtSourceCoderUIModel [
	sourceCoderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	completion
		ifNotNil: [ :aPreviousCompletion | aPreviousCompletion uninstall ].

	self editorElement editor removeEditorShortcuts: interactions.

	sourceCoderUIModel := aGtSourceCoderUIModel.
	actions coder: aGtSourceCoderUIModel coder.

	aGtSourceCoderUIModel editorState
		ifNotNil: [ :anEditorState | self editorElement editor restoreState: anEditorState ]
		ifNil: [ self editorElement editor restoreState: BrTextEditorMemento default ].
	
	interactions := aGtSourceCoderUIModel coder shortcuts copy.

	self editorElement text: aGtSourceCoderUIModel coder sourceText.
	self editorElement editor addEditorShortcuts: interactions.
	completion := GtCompletionController
		on: self editorElement
		strategy: aGtSourceCoderUIModel coder completionStrategy.
	completion install.

	(aGtSourceCoderUIModel coder newSourceStylerFrom: self editorElement)
		ifNotNil: [ :styler | self editorElement styler: styler ].

	aGtSourceCoderUIModel announcer weak
		when: GtCoderStylerChanged send: #stylersUpdated: to: self;
		when: GtCoderStyleTextRequest send: #styleTextEvent: to: self;
		when: GtCoderSourceCodeChanged send: #onSourceCodeChanged to: self;
		when: GtCoderParseError send: #reportParseError: to: self.

	aGtSourceCoderUIModel focused
		ifTrue: [ self editorElement requestFocus ]
]

{ #category : #hooks }
GtSourceCoderEditorLook >> onSaveSourceCoderUIModel: aGtSourceCoderUIModel [
	aGtSourceCoderUIModel
		editorState: self editorElement editor saveState.
	aGtSourceCoderUIModel focused: self editorElement hasFocus
]

{ #category : #hooks }
GtSourceCoderEditorLook >> onSourceCodeChanged [
	self widgetDo: [ :aWidget | 
		self editorElement enqueueTask: (
			BlTaskAction new action: [
				(self editorElement text = sourceCoderUIModel coder sourceText)
					ifFalse: [ self editorElement text: sourceCoderUIModel coder sourceText ] ]) ]
]

{ #category : #private }
GtSourceCoderEditorLook >> reportParseError: aGtCoderParseError [
	self 
		reportParseError: aGtCoderParseError errorMessage 
		at: aGtCoderParseError location.
]

{ #category : #private }
GtSourceCoderEditorLook >> reportParseError: aString at: anInteger [
	| text position |
	text := self editorElement editor text.
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	(text from: position to: position)
		attributes: {(GtSourceCoderErrorAttribute for: aString , ' ->')}.
	self editorElement editor moveCursorTo: position
]

{ #category : #private }
GtSourceCoderEditorLook >> sourceChanged [
	"Is sent when the current source code changes due to user input in the editor"

	sourceCoderUIModel ifNotNil: [ :aSourceCoderUIModel | aSourceCoderUIModel coder sourceChanged ]
]

{ #category : #private }
GtSourceCoderEditorLook >> styleText [
	self styleTextAndAfterDo: [  ]
]

{ #category : #private }
GtSourceCoderEditorLook >> styleTextAndAfterDo: aBlock [
	editorElement editor styleTextAndAfterDo: aBlock
]

{ #category : #private }
GtSourceCoderEditorLook >> styleTextEvent: anEvent [
	self styleTextAndAfterDo: anEvent afterAction
]

{ #category : #private }
GtSourceCoderEditorLook >> stylersUpdated: anAnnouncement [
	(anAnnouncement coder newSourceStylerFrom: self editorElement)
		ifNotNil: [ :styler | self editorElement styler: styler ]
]
