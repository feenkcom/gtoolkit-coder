Class {
	#name : #GtFilterToggleSettingsElement,
	#superclass : #GtFilterSettingsElement,
	#instVars : [
		'toggleGroupElement'
	],
	#category : 'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterToggleSettingsElement >> initialize [
	super initialize.
	self initializeToggleGroupElement.

	self addChild: toggleGroupElement as: #toggles.
	self initializeEventHandlers.
	self initializeShortcuts
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> initializeEventHandlers [
	self when: GtFilterEditWish do: [ :anEvent | self onEditWish: anEvent ].
	self
		when: GtFilterFocusFirstPartWish
		do: [ :anEvent | self onFocusFirstPartWish: anEvent ]
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> initializeShortcuts [
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> initializeToggleGroupElement [
	toggleGroupElement := BrToggleGroup new
			aptitude: GtFilterToggleGroupAptitude new;
			when: BrToggleActivatedEvent
				do: [ :anEvent | self onToggleActivatedEvent: anEvent ];
			withAsyncFutureDo: [ :anElementFuture |
				anElementFuture
					executionConfiguration: (self class futureExecutionConfiguration);
					whenPending: [ :theToggleGroup |
						self 
							updateToggleElement: theToggleGroup 
							items: { GtFilterModelComputingItem default } ];
					whenError: [ :theToggleGroup :anError |
						self 
							updateToggleElement: theToggleGroup 
							items: { GtFilterModelExceptionItem freeze: anError } ];
					whenSuccess: [ :theToggleGroup :aCollection |
						self updateToggleElement: theToggleGroup items: aCollection ] ]
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> interruptToggleGroupFuture [
	toggleGroupElement withAsyncFutureDo: [ :anElementFuture | 
			anElementFuture 
				cancelHard;
				interrupt ]
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> newAptitudeForItem: anItem [
	| anAptitude |
	anAptitude := anItem
			ifIconAndLabel: [ BrGlamorousToggleWithIconAndLabelAptitude new ]
			ifIcon: [ BrGlamorousToggleWithIconAptitude new ]
			ifLabel: [ BrGlamorousToggleWithLabelAptitude new ].

	anAptitude - BrGlamorousToggleBackgroundAptitude.
	anAptitude + GtFilterToggleBackgroundAptitude.
			
	^ anAptitude
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> newToggleForItem: aFilterItem index: anIndex [
	| aToggle |
	aToggle := BrToggle new.
	aToggle id: (GtFilterItemId indexed: anIndex).
	aToggle beFocusable.
	aToggle beSmallSize.
	aToggle viewModel model: aFilterItem.
	aFilterItem == self filterViewModel selectedItem ifTrue: [ aToggle activate ].
	aFilterItem ifIcon: [ :anIcon | aToggle icon: anIcon ].
	aFilterItem ifLabel: [ :aLabel | aToggle label: aLabel ].
	aToggle aptitude: (self newAptitudeForItem: aFilterItem).
	aToggle addAptitude: (BrStyleCommonAptitude new 
		// #label;
		default: [ :aStyle | aStyle foreground: self theme button defaultTextColor ];
		focused: [ :aStyle | aStyle foreground: self theme button hoveredTextColor ]).
	aToggle
		when: BlMouseEnterEvent
		do: [ :anEvent | self onToggleMouseEnterEvent: anEvent ].
	
	self registerNavigationShortcutsForToggle: aToggle.
	^ aToggle
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> onEditWish: anEvent [
	anEvent consumed: true.
	self requestToggleFocus
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onFiltersViewModelItemRemoved: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self interruptToggleGroupFuture ]
]

{ #category : #'api - filter view model' }
GtFilterToggleSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.
	self updateElement
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onFocusFirstPartWish: anEvent [
	anEvent consumed: true.
	self requestToggleFocus
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onItemsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onSelectedItemChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateActiveToggle ]
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> onToggleActivatedEvent: anEvent [ 
	self hasFilterViewModel ifFalse: [ ^ self ].
	anEvent toggle model ifNotNil: [ :anItem | 
		self filterViewModel selectedItem: anItem ]
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onToggleEnterShortcutEvent: anEvent [
	self hasFilterViewModel ifFalse: [ ^ self ].
	anEvent consumed: true.
	anEvent currentTarget activate.
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onToggleMouseEnterEvent: anEvent [
	"Change focused if another toggle is focused."

	| aHoveredToggle aResult |
	anEvent consumed: true.
	aResult := toggleGroupElement viewModel toggles
			anySatisfy: [ :eachToggle | 
				| isToggleFocused |
				isToggleFocused := false.
				eachToggle widgetDo: [ :aWidget | isToggleFocused := aWidget isFocused ].
				isToggleFocused ].
	aResult ifFalse: [ ^ self ].

	aHoveredToggle := anEvent currentTarget.
	aHoveredToggle requestFocus
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onToggleMoveLeftShortcutEvent: anEvent [
	anEvent consumed: true.
	BlFocusFinder new
		left;
		root: toggleGroupElement;
		referenceElement: anEvent currentTarget;
		nextFocusDo: #requestFocus
			ifNone: [ self fireEvent: GtFilterFocusWholeWish new ]
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onToggleMoveRightShortcutEvent: anEvent [
	anEvent consumed: true.
	BlFocusFinder new
		right;
		root: toggleGroupElement;
		referenceElement: anEvent currentTarget;
		nextFocusDo: #requestFocus
			ifNone: [ self fireEvent: GtFilterFocusNextPartWish new ]
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> registerNavigationShortcutsForToggle: aToggle [
	aToggle
		addShortcut: (BlShortcutWithAction new
				name: 'Select filter item';
				description: 'Accept new filter item and store it into the filter model';
				combination: BlKeyCombination enter;
				action: [ :anEvent | self onToggleEnterShortcutEvent: anEvent ]);
		addShortcut: (BlShortcutWithAction new
				name: 'Move previous filter item';
				combination: (BlKeyCombination arrowLeft or: BlKeyCombination shiftTab);
				action: [ :anEvent | self onToggleMoveLeftShortcutEvent: anEvent ]);
		addShortcut: (BlShortcutWithAction new
				name: 'Move next filter item';
				combination: (BlKeyCombination arrowRight or: BlKeyCombination tab);
				action: [ :anEvent | self onToggleMoveRightShortcutEvent: anEvent ])
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> requestToggleFocus [
	toggleGroupElement viewModel hasActivatedToggle
		ifTrue: [ toggleGroupElement activatedToggle requestFocus ]
		ifFalse: [ toggleGroupElement viewModel toggles
				ifNotEmpty: [ :aCollection | aCollection first widgetDo: [ :aWidget |
					aWidget requestFocus ] ] ]
]

{ #category : #'api - filter view model' }
GtFilterToggleSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.
	self filterViewModel weak
		when: GtFilterViewModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterViewModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self;
		when: GtFiltersViewModelItemRemoved
			send: #onFiltersViewModelItemRemoved:
			to: self.
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> updateActiveToggle [
	| aSelectedItem |
	aSelectedItem := self filterViewModel selectedItem.
	toggleGroupElement activatedToggle viewModel model == aSelectedItem
		ifTrue: [ ^ self ].
	toggleGroupElement viewModel toggles
		do: [ :eachToggle | 
			eachToggle viewModel model == aSelectedItem 
				ifTrue: [ eachToggle activate ] ]
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> updateElement [
	self updateToggles
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> updateToggleElement: aToggleGroup items: aCollection [ 
	aToggleGroup removeToggles.

	aCollection doWithIndex: [ :eachItem :anIndex | 
		| aToggle |
		aToggle := self newToggleForItem: eachItem index: anIndex.
		aToggleGroup addToggle: aToggle ]
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> updateToggles [
	self hasFilterViewModel ifFalse: [ ^ self ].
	
	toggleGroupElement withAsyncFutureDo: [ :anElementFuture |
		anElementFuture future: self filterViewModel itemsFuture asAsyncFuture ].
]
