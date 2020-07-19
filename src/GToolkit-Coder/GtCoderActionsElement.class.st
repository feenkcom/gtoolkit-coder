Class {
	#name : #GtCoderActionsElement,
	#superclass : #BlElement,
	#instVars : [
		'mainToolbar',
		'contextToolbar',
		'separator',
		'coder',
		'editor'
	],
	#category : #'GToolkit-Coder-UI - Source Coder'
}

{ #category : #private }
GtCoderActionsElement >> addContextToolbarActions [
	contextToolbar addItems: (coder contextActions collect: [ :aGtCoderAction | self newButtonForAction: aGtCoderAction ]).
	separator
		visibility:
			(contextToolbar hasItems
				ifTrue: [ BlVisibility visible ]
				ifFalse: [ BlVisibility gone ])
]

{ #category : #private }
GtCoderActionsElement >> addMainToolbarActions [
	mainToolbar addItems: (coder mainActions collect: [ :aGtCoderAction | 
		self flag: 'Temporary hack. Coder should to Phlow actions'.
		aGtCoderAction class = GtCoderDropDownAction 
			ifTrue: [ self newDropButtonForAction: aGtCoderAction ] 
			ifFalse: [ self newButtonForAction: aGtCoderAction  ] ])
]

{ #category : #accessing }
GtCoderActionsElement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderActionsElement >> coder: aCoder [
	coder ifNotNil: [ :aPreviousCoder | aPreviousCoder announcer unsubscribe: self ].

	coder := aCoder.
	coder announcer weak
		when: GtCoderAddOnsUpdateRequest send: #updateAddOns: to: self;
		when: GtCoderMainActionsChanged send: #updateMainToolbar to: self;
		when: GtCoderContextActionsChanged send: #updateContextToolbar to: self.
	
	coder shouldAddOnsBeUpdated
		ifTrue: [ coder updateAddOnsFrom: self ].	

	self removeMainToolbarActions.
	self removeContextToolbarActions.

	self addMainToolbarActions.
	self addContextToolbarActions
]

{ #category : #accessing }
GtCoderActionsElement >> editor [
	<return: #BrEditorElement>

	^ editor
]

{ #category : #accessing }
GtCoderActionsElement >> editor: aBrEditorElement [
	editor := aBrEditorElement
]

{ #category : #initialization }
GtCoderActionsElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.
	self padding: (BlInsets empty).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	mainToolbar := self newToolbar labeled: 'Main toolbar'.
	
	separator := BlElement new
		background: (Color gray alpha: 0.2);
		margin: (BlInsets all: 5);
		constraintsDo: [ :c |
			c horizontal exact: 1.
			c vertical matchParent ].

	contextToolbar := self newToolbar labeled: 'Context toolbar'.

	self addChildren: { mainToolbar . separator . contextToolbar }
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newButtonForAction: aGtCoderAction [
	<return: #BrButton>
	
	^ BrButton new
		icon: aGtCoderAction icon asElement;
		beSmall;
		label: aGtCoderAction title;
		look: BrGlamorousButtonWithIconLook;
		action: [ :aButtonElement :aButtonModel :anEvent |
			self editor ifNotNil: [ :anEditorElement | aGtCoderAction action glamourValueWithArgs: { anEditorElement . anEvent } ] ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newDropButtonForAction: aGtCoderAction [
	<return: #BrButton>
	| withLook button |
	button := BrButton new.
	aGtCoderAction title
		ifNotNil: [ button label: aGtCoderAction title asRopedText ].
	aGtCoderAction icon
		ifNotNil: [ button icon: aGtCoderAction icon asElement ].
	^ button
		beSmall;
		padding: BlInsets empty;
		margin: BlInsets empty;
		look:
			BrGlamorousButtonWithIconLook
				+
					(withLook := BrGlamorousWithDropdownLook
						handle: [ | aButton |
							aButton := BrButton new.
							aGtCoderAction title
								ifNotNil: [ aButton label: aGtCoderAction title asRopedText ].
							aGtCoderAction icon
								ifNotNil: [ aButton icon: aGtCoderAction icon asElement ].
							aButton
								beSmall;
								look: BrGlamorousButtonWithIconLook 
									- BrGlamorousButtonWithLabelTooltipLook
									- BrGlamorousButtonExteriorLook;
								padding: BlInsets empty;
								margin: BlInsets empty;
								yourself ]
						content: [ | classCompleter containerElement titleElement |
							containerElement := BlElement new
								layout: BlLinearLayout vertical;
								constraintsDo: [ :c | 
									c horizontal exact: 200.
									c vertical fitContent ].
							titleElement := BrEditorElement new
								look: BrGlamorousInputFieldSpacingLook;
								editor: (BrTextEditor new text: '' asRopedText);
								requestFocus;
								constraintsDo: [ :c | 
									c margin: (BlInsets top: 1 left: 0 bottom: 0 right: 0).
									c horizontal matchParent.
									c vertical fitContent ].
							classCompleter := GtCompletionController
								on: titleElement
								strategy: GtCoderClassWithPackageCompletionStrategy new.
							classCompleter install.
							classCompleter announcer
								when: GtCompleterCompletionAccepted
								do: [ :event | 
									aGtCoderAction action value: titleElement editor text asString asClass.
									withLook hide ].
							containerElement addChild: titleElement.
							containerElement ]);
		yourself
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newToolbar [
	<return: #BrToolbar>

	^ BrToolbar new
		look: (BrGlamorousToolbarLook new spacing: 4);
		padding: (BlInsets left: -4)
]

{ #category : #private }
GtCoderActionsElement >> removeContextToolbarActions [
	contextToolbar numberOfItems timesRepeat: [ contextToolbar removeItemAt: 1 ]
]

{ #category : #private }
GtCoderActionsElement >> removeMainToolbarActions [
	mainToolbar numberOfItems timesRepeat: [ mainToolbar removeItemAt: 1 ]
]

{ #category : #private }
GtCoderActionsElement >> updateAddOns: anAnnouncement [
	anAnnouncement coder updateAddOnsFrom: self
]

{ #category : #private }
GtCoderActionsElement >> updateContextToolbar [
	self
		enqueueTask:
			(BlTaskAction new
				action: [ self removeContextToolbarActions.
					self addContextToolbarActions ])
]

{ #category : #private }
GtCoderActionsElement >> updateMainToolbar [
	self
		enqueueTask:
			(BlTaskAction new
				action: [ self removeMainToolbarActions.
					self addMainToolbarActions ])
]
