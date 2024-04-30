Class {
	#name : #GtSourceCoderActionsElement,
	#superclass : #GtCoderActionsElement,
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
GtSourceCoderActionsElement >> addContextToolbarActions [
	contextToolbar addItems: (self textualCoderViewModel contextActions collect: [ :aGtCoderAction | 
		aGtCoderAction buildElementIn: self ]).
	separator
		visibility:
			(contextToolbar hasItems
				ifTrue: [ BlVisibility visible ]
				ifFalse: [ BlVisibility gone ])
]

{ #category : #private }
GtSourceCoderActionsElement >> addMainToolbarActions [
	mainToolbar
		addItems:
			(self coderViewModel mainActions
				collect: [ :aGtCoderAction | 
					self flag: 'Temporary hack. Coder should to Phlow actions'.
					aGtCoderAction buildElementIn: self ])
]

{ #category : #accessing }
GtSourceCoderActionsElement >> coderViewModel [
	^ self textualCoderViewModel
]

{ #category : #accessing }
GtSourceCoderActionsElement >> coderViewModel: aCoderViewModel [
	self textualCoderViewModel: aCoderViewModel
]

{ #category : #initialization }
GtSourceCoderActionsElement >> initialize [
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
GtSourceCoderActionsElement >> newToolbar [
	<return: #BrToolbar>

	^ BrToolbar new
		aptitude: (BrGlamorousToolbarAptitude new spacing: 4);
		padding: (BlInsets left: -4)
]

{ #category : #'private - announcement handling' }
GtSourceCoderActionsElement >> onAboutToOpenDebugger: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self updateDebuggerIndicatorForProcess: anAnnouncement process ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderActionsElement >> onPostTextualCoderViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToTextualCoderViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	
	self textualCoderViewModel ensureAddOns
]

{ #category : #'api - textual coder view model' }
GtSourceCoderActionsElement >> onTextualCoderViewModelChanged [
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
GtSourceCoderActionsElement >> removeContextToolbarActions [
	contextToolbar numberOfItems timesRepeat: [ contextToolbar removeItemAt: 1 ]
]

{ #category : #private }
GtSourceCoderActionsElement >> removeMainToolbarActions [
	mainToolbar numberOfItems timesRepeat: [ mainToolbar removeItemAt: 1 ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderActionsElement >> subscribeToTextualCoderViewModel [
	"Is sent after a new textualCoder view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromTextualCoderViewModel if elements subscribe to them"

	self textualCoderViewModel weak
		when: GtTextualCoderViewModelMainActionsChanged send: #updateMainToolbar to: self;
		when: GtTextualCoderViewModelContextActionsChanged send: #updateContextToolbar to: self;
		when: GtSourceCoderViewModelAboutToOpenDebuggerAnnouncement send: #onAboutToOpenDebugger: to: self.
]

{ #category : #'api - textual coder view model' }
GtSourceCoderActionsElement >> unsubscribeFromTextualCoderViewModel [
	"Is sent before a new textualCoder view model is assigned to the element.
	Elements that subscribe to textualCoder view model in domain model are required to implement this methods."
	
	self textualCoderViewModel unsubscribe: self
]

{ #category : #'private - event handling' }
GtSourceCoderActionsElement >> updateContextToolbar [
	self enqueueTask:
		(BlTaskAction new
			action: [
				self removeContextToolbarActions.
				self addContextToolbarActions ])
]

{ #category : #'private - updating' }
GtSourceCoderActionsElement >> updateDebuggerIndicatorForProcess: aProcess [
	| aSpace |
	aSpace := GtCoderDebuggerSpaceFinder new
			process: aProcess;
			find;
			space.

	GtSourceCoderProcessInDebuggerSignal new
		process: aProcess;
		space: aSpace;
		emit.

	aSpace ifNil: [ ^ self ].
	self textualCoderViewModel addLocateDebuggerInSpaceAction: aSpace
]

{ #category : #'private - event handling' }
GtSourceCoderActionsElement >> updateMainToolbar [
	self enqueueTask: (BlTaskAction new
		action: [			
			self removeMainToolbarActions.
			self addMainToolbarActions ])
]
