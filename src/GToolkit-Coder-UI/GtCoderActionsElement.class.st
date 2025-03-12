Class {
	#name : #GtCoderActionsElement,
	#superclass : #BlElement,
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtCoderActionsElement >> coderViewModel [
	self subclassResponsibility
]

{ #category : #accessing }
GtCoderActionsElement >> coderViewModel: aCoderViewModel [
	self subclassResponsibility
]

{ #category : #'private - event handling' }
GtCoderActionsElement >> disableButton: aButtonElement action: aGtCoderAction [
	aButtonElement
		icon:
			(aGtCoderAction icon asElement
				background: BrGlamorousColors disabledButtonTextColor);
		label: aGtCoderAction title asRopedText , '...' asRopedText;
		disable
]

{ #category : #'private - event handling' }
GtCoderActionsElement >> enqueueEnableButton: aButtonElement action: aGtCoderAction [
	^ aButtonElement
		enqueueTask:
			(BlTaskAction new
				action: [ aButtonElement
						icon: aGtCoderAction icon asElement;
						label: aGtCoderAction title;
						enable ])
]

{ #category : #'private - event handling' }
GtCoderActionsElement >> handleButton: aButtonElement action: aGtCoderAction onEvent: anEvent [
	self disableButton: aButtonElement action: aGtCoderAction.
	GtCoderExecutionContextVariable
		element: aButtonElement
		do: [ aButtonElement
				enqueueTask: (BlTaskAction new
						action: [ [ aGtCoderAction action
								gtValueWithArgs: {self coderViewModel.
										aButtonElement.
										anEvent} ]
								ensure: [ self enqueueEnableButton: aButtonElement action: aGtCoderAction ] ]) ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> initializeAltClick: aGtCoderAction element: anElement [
	aGtCoderAction allowAltClick ifFalse: [ ^ self ].

	anElement viewModel
		when: BlClickEvent
		do: [ :anEvent | 
			anEvent modifiers isAlt
				ifTrue: [ anEvent consumed: true.
					anEvent target phlow spawnObject: aGtCoderAction actionDefinition ] ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> initializePrimaryClick: aGtCoderAction element: button [
	aGtCoderAction allowPrimaryClick
		ifTrue: [ button viewModel
				when: BlClickEvent
				do: [ :anEvent | 
					anEvent modifiers isPrimaryModifier
						ifTrue: [ button viewModel clickEvent: anEvent ] ].
			button viewModel
				when: BlMouseEnterEvent
				do: [ :anEvent | 
					anEvent consumed: true.
					anEvent modifiers isPrimaryModifier
						ifTrue: [ anEvent target mouseCursor: BlCopyCursor new ]
						ifFalse: [ anEvent target mouseCursor: nil ].
					anEvent target requestFocus ] ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newButtonForAction: aGtCoderAction [
	<return: #BrButton>
	| button |
	button := BrButton new
			icon: aGtCoderAction icon asElement;
			beTinySize;
			label: aGtCoderAction title;
			constraintsDo: [ :c | c linear vertical alignCenter ];
			aptitude: BrGlamorousButtonWithIconAptitude;
			in: [ :aButtonElement | aButtonElement id: aGtCoderAction id ];
			action: [ :aButtonElement :aButtonModel :anEvent | 
				self
					handleButton: aButtonElement
					action: aGtCoderAction
					onEvent: anEvent ].
	aGtCoderAction isDisabled ifTrue: [
		self disableButton: button action: aGtCoderAction ].
	
	self initializeAltClick: aGtCoderAction element: button.
	self initializePrimaryClick: aGtCoderAction element: button.
	^ button
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newDropButtonDefaultMenuForAction: aGtCoderAction [
	| titleElement containerElement classCompleter |
	containerElement := BlElement new
			layout: BlLinearLayout vertical;
			constraintsDo: [ :c | 
				c horizontal exact: 200.
				c vertical fitContent ].
	titleElement := BrEditorElement new
			aptitude: BrGlamorousInputFieldSpacingAptitude;
			editor: (BrTextEditorModel new text: '' asRopedText);
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
	^ containerElement
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newDropButtonForAction: aGtCoderAction [
	<return: #BrButton>
	| button aContentStencil |
	button := BrButton new.

	aGtCoderAction title
		ifNotNil: [ button label: aGtCoderAction title asRopedText ].
	aGtCoderAction icon ifNotNil: [ button icon: aGtCoderAction icon asElement ].

	aContentStencil := aGtCoderAction stencil
			ifNil: [ self newDropButtonDefaultMenuForAction: aGtCoderAction ].

	self initializeAltClick: aGtCoderAction element: button.

	^ button
		beTinySize;
		aptitude: BrGlamorousButtonWithIconAptitude
				+ (BrGlamorousWithExplicitDropdownAptitude
						handle: [ | aButton |
							aButton := BrButton new.
							aGtCoderAction title
								ifNotNil: [ aButton label: aGtCoderAction title asRopedText ].
							aGtCoderAction icon
								ifNotNil: [ aButton icon: aGtCoderAction icon asElement ].
							aButton
								beSmallSize;
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
										- BrGlamorousButtonExteriorAptitude;
								padding: BlInsets empty;
								margin: BlInsets empty;
								yourself ]
						content: aContentStencil);
		yourself
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newDropButtonMenuForAction: aGtCoderAction [
	<return: #BrButton>
	| button aMenuStencil |
	button := BrButton new.

	aGtCoderAction title
		ifNotNil: [ button label: aGtCoderAction title asRopedText ].
	aGtCoderAction icon ifNotNil: [ button icon: aGtCoderAction icon asElement ].

	aMenuStencil := aGtCoderAction menuStencil
			ifNil: [ [ BrMenuExplicit new
					stencil: [ self newDropButtonDefaultMenuForAction: aGtCoderAction ] ] ].

	self initializeAltClick: aGtCoderAction element: button.

	^ button
		beTinySize;
		aptitude: BrGlamorousButtonWithIconAptitude
				+ (BrGlamorousWithExplicitDropdownAptitude
						handle: [ | aButton |
							aButton := BrButton new.
							aGtCoderAction title
								ifNotNil: [ aButton label: aGtCoderAction title asRopedText ].
							aGtCoderAction icon
								ifNotNil: [ aButton icon: aGtCoderAction icon asElement ].
							aButton
								beSmallSize;
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
										- BrGlamorousButtonExteriorAptitude;
								padding: BlInsets empty;
								margin: BlInsets empty;
								yourself ]
						menu: aMenuStencil);
		yourself
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newLocateDebuggerButtonForAction: aGtCoderAction [
	<return: #BrButton>
	| button anAptitude |
	button := BrButton new
			icon: aGtCoderAction icon asElement;
			beTinySize;
			label: aGtCoderAction title;
			id: aGtCoderAction id;
			action: [ :aButtonElement :aButtonModel :anEvent | 
				self
					handleButton: aButtonElement
					action: aGtCoderAction
					onEvent: anEvent ].

	anAptitude := BrGlamorousButtonWithIconAndLabelAptitude new.
	anAptitude
		findActor: BrGlamorousButtonExteriorAptitude
		ifFound: [ :anExteriorAptitude | 
			anExteriorAptitude
				"backgroundPaint: BrGlamorousColors errorBackgroundColor;"
				"borderPaint: BrGlamorousColors errorBorderColor" ]
		ifNone: [  ].
	anAptitude
		findActor: BrGlamorousButtonLabelAptitude
		ifFound: [ :aLabelAptitude | 
			"aLabelAptitude
				defaultColor: BrGlamorousColors errorBackgroundColor;
				hoveredColor: BrGlamorousColors errorBorderColor;
				pressedColor: BrGlamorousColors errorBorderColor;
				selectedColor: BrGlamorousColors errorBackgroundColor" ]
		ifNone: [  "ignore" ].
	button aptitude: anAptitude.

	self initializeAltClick: aGtCoderAction element: button.
	self initializePrimaryClick: aGtCoderAction element: button.
	^ button
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newToggleForAction: aGtCoderAction [
	<return: #BrToggle>
	^ BrToggle new
		aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousToggleBackgroundAptitude;
		icon: aGtCoderAction icon asElement;
		beTinySize;
		label: aGtCoderAction title;
		in: [ :aToggle | self initializeAltClick: aGtCoderAction element: aToggle ];
		id: aGtCoderAction id;
		yourself
]
