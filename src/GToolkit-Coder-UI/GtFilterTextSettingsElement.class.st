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
	self addChild: editorElement as: #editor.
	self initializeEventHandlers.
]

{ #category : #initialization }
GtFilterTextSettingsElement >> initializeEditorElement [
	editorElement := BrEditor new
			hFitContentLimited;
			vFitContent;
			beMode: BrTextEditorEditableSingleLineMode new;
			background: self theme default contentBackgroundColor;
			aptitude: BrGlamorousRegularEditorAptitude new 
				glamorousRegularSmallSize;
			text: '';
			padding: (BlInsets top: 1 right: 2 bottom: 1 left: 2);
			constraintsDo: [ :c | c minWidth: 20 ];
			addShortcut: (BlShortcutWithAction new
				name: 'Accept new text';
				description: 'Accept new text and store it into the filter model';
				combination: BlKeyCombination enter;
				action: [ :anEvent |
					self onTextEditorModificationAccepted: anEvent ]);
			addShortcut: (BlShortcutWithAction new
				name: 'Move cursor left or focus current filter';
				combination: (BlKeyCombination arrowLeft);
				action: [ :anEvent |
					self onTextEditorArrowLeftEvent: anEvent ]);
			addShortcut: (BlShortcutWithAction new
				name: 'Move cursor right or focus next filter';
				combination: (BlKeyCombination arrowRight);
				action: [ :anEvent |
					self onTextEditorArrowRightEvent: anEvent ]);
			addShortcut: (BlShortcutWithAction new
				name: 'Focus previous filter';
				combination: (BlKeyCombination shiftTab);
				action: [ :anEvent |
					self onTextEditorShiftTabEvent: anEvent ]);
			addShortcut: (BlShortcutWithAction new
				name: 'Focus next filter';
				combination: (BlKeyCombination tab);
				action: [ :anEvent |
					self onTextEditorTabEvent: anEvent ]);
			addShortcut: (BlShortcutWithAction new
				name: 'Delete text or focus current filter';
				combination: (BlKeyCombination backspace);
				action: [ :anEvent |
					self onTextEditorDeleteEvent: anEvent ]);
			when: BlFocusInEvent do: [ :anEvent | 
				anEvent currentTarget selecter all select ]; 
			when: BlFocusOutEvent do: [ :anEvent |
					anEvent currentTarget deselecter all deselect.
				anEvent isDueToRemoval ifFalse: [
					self onTextEditorModificationAccepted: anEvent ] ]
]

{ #category : #initialization }
GtFilterTextSettingsElement >> initializeEventHandlers [
	self when: GtFilterEditWish do: [ :anEvent | self onEditWish: anEvent ].
	self
		when: GtFilterFocusFirstPartWish
		do: [ :anEvent | self onFocusFirstPartWish: anEvent ]
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onEditWish: anEvent [
	anEvent consumed: true.
	editorElement requestFocus
]

{ #category : #'api - filter view model' }
GtFilterTextSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.

	self updateEditorElement
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onFocusFirstPartWish: anEvent [
	anEvent consumed: true.
	editorElement requestFocus
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
GtFilterTextSettingsElement >> onTextEditorArrowLeftEvent: anEvent [
	| anElement anEditor |
	anElement := anEvent currentTarget.
	anEditor := anElement editor.
	anEvent consumed: true.
	(anEditor cursors positions includes: 0)
		ifTrue: [ self fireEvent: GtFilterFocusWholeWish new.
			^ self ].

	anEditor selection isEmpty
		ifTrue: [ anEditor navigator
				moveLeft;
				apply ]
		ifFalse: [ anEditor deselecter
				all;
				deselect ]
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextEditorArrowRightEvent: anEvent [
	| anElement anEditor |
	anElement := anEvent currentTarget.
	anEditor := anElement editor.
	anEvent consumed: true.
	(anEditor cursors positions includes: anEditor text size)
		ifTrue: [ self fireEvent: GtFilterFocusNextPartWish new.
			^ self ].

	anEditor selection isEmpty
		ifTrue: [ anEditor navigator
				moveRight;
				apply ]
		ifFalse: [ anEditor deselecter
				all;
				deselect ]
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextEditorDeleteEvent: anEvent [
	| anElement anEditor |
	anElement := anEvent currentTarget.
	anEditor := anElement editor.
	anEvent consumed: true.
	(anEditor cursors positions includes: 0)
		ifTrue: [ self fireEvent: GtFilterFocusWholeWish new.
			^ self ].

	anEditor deleter
		selected;
		oneBeforeCursorIfOutsideOfSelection;
		surroundings: anEditor surroundMap;
		delete
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextEditorModificationAccepted: anEvent [
	self hasFilterViewModel ifFalse: [ ^ self ].
	anEvent consumed: true.
	self filterViewModel
		text: (editorElement text copy trimmer
				bothSeparators;
				trimmed)
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextEditorShiftTabEvent: anEvent [
	anEvent consumed: true.
	self fireEvent: GtFilterFocusWholeWish new
]

{ #category : #'event handling' }
GtFilterTextSettingsElement >> onTextEditorTabEvent: anEvent [
	anEvent consumed: true.
	self fireEvent: GtFilterFocusNextPartWish new
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
