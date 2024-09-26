Class {
	#name : #GtFilterTextSettingsElement,
	#superclass : #GtFilterSettingsElement,
	#instVars : [
		'editorElement',
		'completionController'
	],
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterTextSettingsElement >> initialize [
	super initialize.
	self initializeEditorElement.
	self addChild: editorElement as: #editor
]

{ #category : #initialization }
GtFilterTextSettingsElement >> initializeEditorElement [
	editorElement := BrEditor new
			hFitContentLimited;
			vFitContent;
			background: self theme default contentBackgroundColor;
			aptitude: BrGlamorousRegularEditorAptitude new 
				glamorousRegularSmallSize;
			text: '';
			padding: (BlInsets top: 1 right: 2 bottom: 1 left: 2);
			constraintsDo: [ :c | c minWidth: 20 ];
			addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent |
					self onTextEditorModificationAccepted: anEvent ]);
			when: BlFocusOutEvent do: [ :anEvent |
				anEvent isDueToRemoval ifFalse: [
					self onTextEditorModificationAccepted: anEvent ] ].
]

{ #category : #'api - filter view model' }
GtFilterTextSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.

	self updateEditorElement
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onInputFilterChanged: anAnnouncement [
	BlTaskAction 
		enqueueElement: self 
		action: [ self updateEditorElementInputFilter ]
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextChanged: anAnnouncement [
	BlTaskAction 
		enqueueElement: self 
		action: [ self updateEditorElementText ]
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextEditorModificationAccepted: anEvent [
	self hasFilterViewModel ifFalse: [ ^ self ].
	self filterViewModel
		text: (editorElement text copy trimmer
				bothSeparators;
				trimmed)
]

{ #category : #'api - filter view model' }
GtFilterTextSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.

	self filterViewModel weak
		when: GtFilterTextViewModelTextChanged
			send: #onTextChanged:
			to: self;
		when: GtFilterTextViewModelInputFilterChanged
			send: #onInputFilterChanged:
			to: self
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorCompletionController [
	completionController ifNotNil: [ :aController |
		completionController := nil.
		aController uninstall ].

	self filterViewModel completionDo: [ :aStrategy | 
		completionController := GtCompletionController on: editorElement strategy: aStrategy.
		completionController install ]
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElement [
	self updateEditorElementInputFilter.
	self updateEditorElementText.
	self updateEditorCompletionController.
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElementInputFilter [
	(editorElement editor inputFilter = self filterViewModel inputFilter)
		ifTrue: [ ^ self ].
	
	editorElement inputFilter: self filterViewModel inputFilter
]

{ #category : #'private - updating' }
GtFilterTextSettingsElement >> updateEditorElementText [
	| aText aTrimmedText |
	aText := self filterViewModel text.
	(editorElement text equals: aText) ifTrue: [ ^ self ].
	
	aTrimmedText := aText trimmer
			bothSeparators;
			trimmed.
	editorElement text: aTrimmedText
]
