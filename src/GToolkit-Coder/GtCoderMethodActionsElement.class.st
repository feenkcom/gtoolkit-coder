Class {
	#name : #GtCoderMethodActionsElement,
	#superclass : #BlElement,
	#instVars : [
		'mainToolbar',
		'contextToolbar',
		'separator',
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #private }
GtCoderMethodActionsElement >> addContextToolbarActions [
	contextToolbar addItems: (methodCoder contextActions collect: [ :aGtCoderAction | self newButtonForAction: aGtCoderAction ]).
	separator
		visibility:
			(contextToolbar hasItems
				ifTrue: [ BlVisibility visible ]
				ifFalse: [ BlVisibility gone ])
]

{ #category : #private }
GtCoderMethodActionsElement >> addMainToolbarActions [
	mainToolbar addItems: (methodCoder mainActions collect: [ :aGtCoderAction | 
		self flag: 'Temporary hack. Coder should to Phlow actions'.
		aGtCoderAction class = GtCoderDropDownAction 
			ifTrue: [ self newDropButtonForAction: aGtCoderAction ] 
			ifFalse: [ self newButtonForAction: aGtCoderAction  ] ])
]

{ #category : #initialization }
GtCoderMethodActionsElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.
	self padding: (BlInsets empty).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	mainToolbar := self newToolbar.
	
	separator := BlElement new
		background: (Color gray alpha: 0.2);
		margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5);
		constraintsDo: [ :c |
			c horizontal exact: 1.
			c vertical matchParent ].

	contextToolbar := self newToolbar.

	self addChildren: { mainToolbar . separator . contextToolbar }
]

{ #category : #accessing }
GtCoderMethodActionsElement >> methodCoder [
	<return: #GtMethodCoder>

	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodActionsElement >> methodCoder: aGtMethodCoder [
	methodCoder := aGtMethodCoder.
	methodCoder announcer weak
		when: GtCoderMethodMainActionsChanged send: #updateMainToolbar to: self;
		when: GtCoderMethodContextActionsChanged send: #updateContextToolbar to: self.
	self addMainToolbarActions.
	self addContextToolbarActions
]

{ #category : #'instance creation' }
GtCoderMethodActionsElement >> newButtonForAction: aGtCoderAction [
	<return: #BrButton>
	
	^ BrButton new
		beSmall;
		look: BrGlamorousButtonWithIconLook;
		label: aGtCoderAction title;
		icon: aGtCoderAction icon asElement;
		action: aGtCoderAction
]

{ #category : #'instance creation' }
GtCoderMethodActionsElement >> newDropButtonForAction: aGtCoderAction [
	<return: #BrDropdown>
	| dropDown |
	dropDown := BrDropdown new.
	dropDown
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		look: BrGlamorousDropdownLook new;
		padding: BlInsets empty;
		margin: BlInsets empty;
		toggle: [ | aButton |
			aButton := BrButton new.
			aGtCoderAction title
				ifNotNil: [ aButton label: aGtCoderAction title asRopedText ].
			aGtCoderAction icon
				ifNotNil: [ aButton icon: aGtCoderAction icon asElement ].
			aButton
				beSmall;
				action: [ dropDown toggle ];
				look: BrGlamorousButtonWithIconLook;
				padding: BlInsets empty;
				margin: BlInsets empty ];
		popup: [ | classCompleter containerElement titleElement |
			containerElement := BlElement new
				layout: BlLinearLayout vertical;
				constraintsDo: [ :c | 
					c horizontal exact: 200.
					c vertical matchParent ].
			titleElement := BrEditorElement new
				look: BrGlamorousInputFieldSpacingLook;
				editor: (BrTextEditor new text: '' asRopedText);
				requestFocus;
				constraintsDo: [ :c | 
					c
						margin:
							(BlInsets
								top: 1
								left: 0
								bottom: 0
								right: 0).
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
					dropDown toggle ].
			containerElement addChild: titleElement.
			containerElement ].
	^ dropDown

	"^ ((GtPhlowDropdownAction new
		label: aGtCoderAction title;
		icon: aGtCoderAction icon asElement;
		popup: [
			 ])
				asElement: [ :anActionElement | 
					anActionElement ] withHostElement: self)"
]

{ #category : #'instance creation' }
GtCoderMethodActionsElement >> newToolbar [
	<return: #BrToolbar>

	^ BrToolbar new
		look: BrToolbarLook new;
		layout: (BlGridLayout horizontal rowCount: 1; cellSpacing: 3);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #private }
GtCoderMethodActionsElement >> removeContextToolbarActions [
	contextToolbar numberOfItems timesRepeat: [ contextToolbar removeItemAt: 1 ]
]

{ #category : #private }
GtCoderMethodActionsElement >> removeMainToolbarActions [
	mainToolbar numberOfItems timesRepeat: [ mainToolbar removeItemAt: 1 ]
]

{ #category : #private }
GtCoderMethodActionsElement >> updateContextToolbar [
	self removeContextToolbarActions.
	self addContextToolbarActions
]

{ #category : #private }
GtCoderMethodActionsElement >> updateMainToolbar [
	self removeMainToolbarActions.
	self addMainToolbarActions
]
