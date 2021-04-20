Class {
	#name : #GtCoderActionsElement,
	#superclass : #BlElement,
	#traits : 'TGtWithTextualCoderViewModel',
	#classTraits : 'TGtWithTextualCoderViewModel classTrait',
	#instVars : [
		'mainToolbar',
		'contextToolbar',
		'separator',
		'editor'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #private }
GtCoderActionsElement >> addContextToolbarActions [
	contextToolbar addItems: (self textualCoderViewModel contextActions collect: [ :aGtCoderAction | self newButtonForAction: aGtCoderAction ]).
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
			(self textualCoderViewModel mainActions
				collect: [ :aGtCoderAction | 
					self flag: 'Temporary hack. Coder should to Phlow actions'.
					aGtCoderAction buildElementIn: self ])
]

{ #category : #accessing }
GtCoderActionsElement >> coderUIModel [
	^ self textualCoderViewModel
]

{ #category : #accessing }
GtCoderActionsElement >> coderUIModel: aCoderUIModel [
	self textualCoderViewModel: aCoderUIModel
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
		aptitude: BrGlamorousButtonWithIconAptitude;
		in: [ :aButtonElement | aButtonElement id: aGtCoderAction id ];
		action: [ :aButtonElement :aButtonModel :anEvent | 
			GtCoderExecutionContextVariable
				element: aButtonElement
				do: [ | aCurrentTarget |
					aCurrentTarget := anEvent currentTarget.
					[ anEvent forwardingTarget: aButtonElement.
					aGtCoderAction action
						glamourValueWithArgs:
							{self textualCoderViewModel.
							anEvent} ]
						ensure: [ anEvent currentTarget: aCurrentTarget ] ] ]
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
GtCoderActionsElement >> newToolbar [
	<return: #BrToolbar>

	^ BrToolbar new
		aptitude: (BrGlamorousToolbarAptitude new spacing: 4);
		padding: (BlInsets left: -4)
]

{ #category : #'api - textual coder view model' }
GtCoderActionsElement >> onPostTextualCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToTextualCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	
	self textualCoderViewModel ensureAddOns
]

{ #category : #'api - textual coder view model' }
GtCoderActionsElement >> onTextualCoderViewModelChanged [
	"Is sent when a new textualCoder view model is assigned to the element.
	Note: #onTextualCoderViewModelChanged is sent before #subscribeToTextualCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostTextualCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self removeMainToolbarActions.
	self removeContextToolbarActions.
	self addMainToolbarActions.
	self addContextToolbarActions
]

{ #category : #private }
GtCoderActionsElement >> removeContextToolbarActions [
	contextToolbar numberOfItems timesRepeat: [ contextToolbar removeItemAt: 1 ]
]

{ #category : #private }
GtCoderActionsElement >> removeMainToolbarActions [
	mainToolbar numberOfItems timesRepeat: [ mainToolbar removeItemAt: 1 ]
]

{ #category : #'api - textual coder view model' }
GtCoderActionsElement >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"

	self textualCoderViewModel weak
		when: GtTextualCoderViewModelMainActionsChanged send: #updateMainToolbar to: self;
		when: GtTextualCoderViewModelContextActionsChanged send: #updateContextToolbar to: self
]

{ #category : #'api - textual coder view model' }
GtCoderActionsElement >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
	
	self textualCoderViewModel unsubscribe: self
]

{ #category : #'private - event handling' }
GtCoderActionsElement >> updateContextToolbar [
	self enqueueTask:
		(BlTaskAction new
			action: [
				self removeContextToolbarActions.
				self addContextToolbarActions ])
]

{ #category : #'private - event handling' }
GtCoderActionsElement >> updateMainToolbar [
	self enqueueTask: (BlTaskAction new
		action: [			
			self removeMainToolbarActions.
			self addMainToolbarActions ])
]
