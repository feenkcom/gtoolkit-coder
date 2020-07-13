Class {
	#name : #GtCoderExpandedContentElement,
	#superclass : #GtCoderContentElement,
	#instVars : [
		'editor',
		'interactions',
		'completion',
		'actions'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'initialize-release' }
GtCoderExpandedContentElement >> coder: aCoder [
	coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].
	editor editor removeEditorShortcuts: interactions.
	"completion ifNotNil: [ :aCompletionController | aCompletionController uninstall ]."

	coder := aCoder.

	breadcrumb removeAllItems.
	breadcrumb addItems: (self newBreadcrumbItemElementsFor: aCoder).
	
	actions coder: aCoder.
	
	interactions := aCoder shortcuts copy.
	"completion := (GtCompletionController on: editor strategy: aCoder completionStrategy)."

	editor editor text: aCoder sourceText.
	editor editor addEditorShortcuts: interactions.
	aCoder newSourceStyler
		ifNotNil: [ :styler | editor editor styler: styler ].
	
	"completion install"
]

{ #category : #'private - menu' }
GtCoderExpandedContentElement >> createContextMenuContent [
	^ coder
		ifNil: [ BlElement new ]
		ifNotNil: [
			coder updateContextMenuAddOns.
			BrCoderContextMenuContent new
				items: (coder contextMenuActions reject: [ :e | e title isNil ]), (coder mainActions reject: [ :e | e title isNil ]);
				yourself ]
]

{ #category : #'initialize-release' }
GtCoderExpandedContentElement >> initialize [
	super initialize.
	
	editor := self newEditorElement.
	editor editor when: BrTextEditorModifiedEvent do: [ self sourceChanged ].

	actions := self newActionsElement editor: editor.
	interactions := #().
	completion := nil.
	
	self look: (BrLayoutResizerLook inherit inherit: editor).
	self addChild: editor as: #editor.
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
