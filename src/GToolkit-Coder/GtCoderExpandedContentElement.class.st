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

{ #category : #'initialize-release' }
GtCoderExpandedContentElement >> coder: aCoder [
	coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	editorElement editor removeEditorShortcuts: interactions.
	"completion ifNotNil: [ :aCompletionController | aCompletionController uninstall ]."

	coder := aCoder.

	breadcrumb removeAllItems.
	breadcrumb addItems: (self newBreadcrumbItemElementsFor: aCoder).
	
	actions coder: aCoder.
	
	interactions := aCoder shortcuts copy.
	"completion := (GtCompletionController on: editor strategy: aCoder completionStrategy)."

	editorElement editor text: aCoder sourceText.
	editorElement editor addEditorShortcuts: interactions.
	aCoder newSourceStyler
		ifNotNil: [ :styler | editorElement editor styler: styler ].
		
	aCoder announcer weak when: GtCoderStyleTextRequest send: #styleText to: self.
	
	"completion install"
]

{ #category : #'private - menu' }
GtCoderExpandedContentElement >> createContextMenuContent [
	^ coder
		ifNil: [ BlElement new ]
		ifNotNil: [
			coder updateContextMenuAddOns.
			GtCoderContextMenuContent new
				items: (coder contextMenuActions reject: [ :e | e title isNil ]), (coder mainActions reject: [ :e | e title isNil ]);
				yourself ]
]

{ #category : #'initialize-release' }
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

{ #category : #'initialize-release' }
GtCoderExpandedContentElement >> newEditorElement [
	^ BrEditorElement new
		look: (BrGlamorousWithContextMenuLook content: [ self createContextMenuContent ]);
		padding: (BlInsets bottom: 2);
		editor: BrTextEditor new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> sourceChanged [
	coder ifNotNil: [ :aCoder | aCoder sourceChanged ]
]

{ #category : #'event handling' }
GtCoderExpandedContentElement >> styleText [
	editorElement editor styleText
]
