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
				enqueueTask:
					(BlTaskAction new
						action: [ [ aGtCoderAction action
								gtValueWithArgs:
									{self coderViewModel.
									aButtonElement} ]
								ensure: [ self enqueueEnableButton: aButtonElement action: aGtCoderAction ] ]) ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newButtonForAction: aGtCoderAction [
	<return: #BrButton>
	^ BrButton new
		icon: aGtCoderAction icon asElement;
		beTinySize;
		label: aGtCoderAction title;
		aptitude: BrGlamorousButtonWithIconAptitude;
		in: [ :aButtonElement | aButtonElement id: aGtCoderAction id ];
		action: [ :aButtonElement :aButtonModel :anEvent | 
			self
				handleButton: aButtonElement
				action: aGtCoderAction
				onEvent: anEvent ]
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newDropButtonForAction: aGtCoderAction [
	<return: #BrButton>
	| button aContentStencil |
	button := BrButton new.

	aGtCoderAction title
		ifNotNil: [ button label: aGtCoderAction title asRopedText ].
	aGtCoderAction icon
		ifNotNil: [ button icon: aGtCoderAction icon asElement ].
		
	aContentStencil := aGtCoderAction stencil
		ifNil: [ | classCompleter containerElement titleElement |
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
					containerElement ].

	^ button
		beTinySize;
		aptitude: BrGlamorousButtonWithIconAptitude +
			(BrGlamorousWithDropdownAptitude
				handle: [ | aButton |
					aButton := BrButton new.
					aGtCoderAction title
						ifNotNil: [ aButton label: aGtCoderAction title asRopedText ].
					aGtCoderAction icon
						ifNotNil: [ aButton icon: aGtCoderAction icon asElement ].
					aButton
						beSmallSize;
						aptitude:
							BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
								- BrGlamorousButtonExteriorAptitude;
						padding: BlInsets empty;
						margin: BlInsets empty;
						yourself ]
				content: aContentStencil);
		yourself
]

{ #category : #'instance creation' }
GtCoderActionsElement >> newToggleForAction: aGtCoderAction [
	<return: #BrToggle>
	^ BrToggle new
		aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousToggleBackgroundAptitude;
		icon: aGtCoderAction icon asElement;
		beTinySize;
		label: aGtCoderAction title;
		in: [ :aButtonElement | aButtonElement id: aGtCoderAction id ]
]
