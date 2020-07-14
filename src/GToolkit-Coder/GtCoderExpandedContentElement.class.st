Class {
	#name : #GtCoderExpandedContentElement,
	#superclass : #GtCoderContentElement,
	#instVars : [
		'interactions',
		'completion',
		'actions',
		'editorElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'api - initialization' }
GtCoderExpandedContentElement >> coder: aCoder [
	coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	self editorElement editor removeEditorShortcuts: interactions.
	"completion ifNotNil: [ :aCompletionController | aCompletionController uninstall ]."

	coder := aCoder.

	breadcrumb ifNotNil: [ :aBreadcrumb | aBreadcrumb coder: aCoder ].
	
	actions coder: aCoder.
	
	interactions := aCoder shortcuts copy.
	"completion := (GtCompletionController on: editor strategy: aCoder completionStrategy)."

	self editorElement text: aCoder sourceText.
	self editorElement editor addEditorShortcuts: interactions.

	(aCoder newSourceStylerFrom: self editorElement)
		ifNotNil: [ :styler | self editorElement styler: styler ].
		
	aCoder announcer weak
		when: GtCoderStylerChanged send: #stylersUpdated: to: self;
		when: GtCoderStyleTextRequest send: #styleText to: self;
		when: GtCoderSourceCodeChanged send: #onSourceCodeChanged to: self;
		when: GtCoderParseError send: #reportParseError: to: self.
	
	"completion install"
]

{ #category : #'private - menu' }
GtCoderExpandedContentElement >> createContextMenuContent [
	^ coder
		ifNil: [ BlElement new ]
		ifNotNil: [
			coder updateContextMenuAddOnsFrom: self editorElement.
			GtCoderContextMenuContent new
				editorElement: self editorElement;
				items: (coder contextMenuActions reject: [ :e | e title isNil ]), (coder mainActions reject: [ :e | e title isNil ]);
				yourself ]
]

{ #category : #'private - accessing' }
GtCoderExpandedContentElement >> editorElement [
	<return: #BrEditorElement>
	^ editorElement
]

{ #category : #initialization }
GtCoderExpandedContentElement >> initialize [
	super initialize.
	
	editorElement := self newEditorElement.
	editorElement editor when: BrTextEditorModifiedEvent do: [ self sourceChanged ].

	actions := self newActionsElement editor: editorElement.
	interactions := #().
	completion := nil.
	
	self look: (BrLayoutResizerLook inherit inherit: editorElement).
	self addChild: editorElement as: #editor.
	self addChild: actions as: #actions
]

{ #category : #'instance creation' }
GtCoderExpandedContentElement >> newActionsElement [
	^ GtCoderActionsElement new
		margin: (BlInsets top: 5);
		yourself
]

{ #category : #'instance creation' }
GtCoderExpandedContentElement >> newEditorElement [
	^ BrEditor new
		look: BrGlamorousCodeEditorLook + (BrGlamorousWithContextMenuLook content: [ self createContextMenuContent ]);
		padding: (BlInsets bottom: 2);
		hMatchParent;
		vFitContent
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> onSourceCodeChanged [
	(self editorElement text = coder sourceText) ifTrue: [ ^ self ].
	self editorElement text: coder sourceText.
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> reportParseError: aGtCoderParseError [
	self 
		reportParseError: aGtCoderParseError errorMessage 
		at: aGtCoderParseError location.
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> reportParseError: aString at: anInteger [
	| text position |
	text := self editorElement editor text.
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	(text from: position to: position)
		attributes: {(GtSourceCoderErrorAttribute for: aString , ' ->')}.
	self editorElement editor moveCursorTo: position
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> sourceChanged [
	"Is sent when the current source code changes due to user input in the editor"

	coder ifNotNil: [ :aCoder | aCoder sourceChanged ]
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> styleText [
	editorElement editor styleText
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> stylersUpdated: anAnnouncement [
	(anAnnouncement coder newSourceStylerFrom: self editorElement)
		ifNotNil: [ :styler | self editorElement styler: styler ]
]
