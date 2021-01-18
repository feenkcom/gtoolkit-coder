Class {
	#name : #GtCoderActionsElement,
	#superclass : #BlElement,
	#instVars : [
		'coderUIModel',
		'mainToolbar',
		'contextToolbar',
		'separator',
		'editor'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #private }
GtCoderActionsElement >> addContextToolbarActions [
	contextToolbar addItems: (coderUIModel coder contextActions collect: [ :aGtCoderAction | self newButtonForAction: aGtCoderAction ]).
	separator
		visibility:
			(contextToolbar hasItems
				ifTrue: [ BlVisibility visible ]
				ifFalse: [ BlVisibility gone ])
]

{ #category : #private }
GtCoderActionsElement >> addMainToolbarActions [
	mainToolbar
		addItems:
			(coderUIModel coder mainActions
				collect: [ :aGtCoderAction | 
					self flag: 'Temporary hack. Coder should to Phlow actions'.
					aGtCoderAction buildElementIn: self ])
]

{ #category : #accessing }
GtCoderActionsElement >> coderUIModel [
	^ coderUIModel
]

{ #category : #accessing }
GtCoderActionsElement >> coderUIModel: aCoderUIModel [
	coderUIModel
		ifNotNil:
			[ :aPreviousCoderUIModel | aPreviousCoderUIModel coder announcer unsubscribe: self ].
	coderUIModel := aCoderUIModel.

	aCoderUIModel coder announcer weak
		when: GtCoderAddOnsUpdateRequest send: #updateAddOns: to: self;
		when: GtCoderMainActionsChanged send: #updateMainToolbar to: self;
		when: GtCoderContextActionsChanged send: #updateContextToolbar to: self.

	aCoderUIModel coder shouldAddOnsBeUpdated
		ifTrue: [ aCoderUIModel coder updateAddOns ].

	self removeMainToolbarActions.
	self removeContextToolbarActions.
	self addMainToolbarActions.
	self addContextToolbarActions
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
		beTinySize;
		label: aGtCoderAction title;
		look: BrGlamorousButtonWithIconLook;
		in: [ :aButtonElement | aButtonElement id: aGtCoderAction id ];
		action: [ :aButtonElement :aButtonModel :anEvent | 
			GtCoderExecutionContextVariable
				element: aButtonElement
				do: [ | aCurrentTarget |
					aCurrentTarget := anEvent currentTarget.
					[ anEvent forwardingTarget: aButtonElement.
					aGtCoderAction action
						glamourValueWithArgs:
							{coderUIModel.
							anEvent} ]
						ensure: [ anEvent currentTarget: aCurrentTarget ] ] ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newDropButtonForAction: aGtCoderAction [
	<return: #BrButton>
	| button |
	button := BrButton new.

	aGtCoderAction title
		ifNotNil: [ button label: aGtCoderAction title asRopedText ].
	aGtCoderAction icon
		ifNotNil: [ button icon: aGtCoderAction icon asElement ].

	^ button
		beTinySize;
		look: BrGlamorousButtonWithIconLook +
			(BrGlamorousWithDropdownLook
				handle: [ | aButton |
					aButton := BrButton new.
					aGtCoderAction title
						ifNotNil: [ aButton label: aGtCoderAction title asRopedText ].
					aGtCoderAction icon
						ifNotNil: [ aButton icon: aGtCoderAction icon asElement ].
					aButton
						beSmallSize;
						look:
							BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
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
							c margin: (BlInsets top: 1).
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
							titleElement fireEvent: BrDropdownHideWish new ].
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
	anAnnouncement coder updateAddOns
]

{ #category : #private }
GtCoderActionsElement >> updateContextToolbar [
	self enqueueTask:
		(BlTaskAction new
			action: [
				self removeContextToolbarActions.
				self addContextToolbarActions ])
]

{ #category : #private }
GtCoderActionsElement >> updateMainToolbar [
	self enqueueTask: (BlTaskAction new
		action: [
			self removeMainToolbarActions.
			self addMainToolbarActions ])
]
