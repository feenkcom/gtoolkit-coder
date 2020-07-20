Class {
	#name : #GtSourceCoderEditorLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'coder',
		'editorElement',
		'interactions',
		'completion',
		'actions'
	],
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> createContextMenuContent [
	^ coder
		ifNil: [ BlElement new ]
		ifNotNil: [
			coder updateContextMenuAddOnsFrom: self editorElement.
			GtCoderContextMenuContent new
				editorElement: self editorElement;
				items: (coder contextMenuActions reject: [ :e | e title isNil ]), (coder mainActions reject: [ :e | e title isNil ]);
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
		do: [ self sourceChanged ].
		
	actions := self newActionsElement editor: editorElement.
		
	interactions := #().
	completion := nil.
	
	self addChangeAddChildAs: #(content editor) with: [ editorElement ].
	self addChangeAddChildAs: #(content actions) with: [ actions ].
	
	self add: (BrLayoutResizerLook new inherit: editorElement)
]

{ #category : #'instance creation' }
GtSourceCoderEditorLook >> newActionsElement [
	^ GtCoderActionsElement new
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
GtSourceCoderEditorLook >> onCoderChanged: aSourceCoder [
	coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	completion ifNotNil: [ :aPreviousCompletion | aPreviousCompletion uninstall ].
	
	self editorElement editor removeEditorShortcuts: interactions.

	coder := aSourceCoder.
	
	actions coder: aSourceCoder.
	
	interactions := aSourceCoder shortcuts copy.
	
	self editorElement text: aSourceCoder sourceText.
	self editorElement editor addEditorShortcuts: interactions.

	completion := (GtCompletionController on: self editorElement strategy: aSourceCoder completionStrategy).
	completion install.

	(aSourceCoder newSourceStylerFrom: self editorElement)
		ifNotNil: [ :styler | self editorElement styler: styler ].

	aSourceCoder announcer weak
		when: GtCoderStylerChanged send: #stylersUpdated: to: self;
		when: GtCoderStyleTextRequest send: #styleText to: self;
		when: GtCoderSourceCodeChanged send: #onSourceCodeChanged to: self;
		when: GtCoderParseError send: #reportParseError: to: self
]

{ #category : #hooks }
GtSourceCoderEditorLook >> onSourceCodeChanged [
	(self editorElement text = coder sourceText)
		ifTrue: [ ^ self ].
	
	self editorElement text: coder sourceText
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

	coder ifNotNil: [ :aCoder | aCoder sourceChanged ]
]

{ #category : #private }
GtSourceCoderEditorLook >> styleText [
	editorElement editor styleText
]

{ #category : #private }
GtSourceCoderEditorLook >> stylersUpdated: anAnnouncement [
	(anAnnouncement coder newSourceStylerFrom: self editorElement)
		ifNotNil: [ :styler | self editorElement styler: styler ]
]
