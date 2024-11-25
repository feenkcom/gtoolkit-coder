Class {
	#name : #GtFilterItemsElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtWithFiltersViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtWithFiltersViewModel classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'private - updating' }
GtFilterItemsElement >> addElementForFilterViewModel: aFilterViewModel index: anIndex [
	| anElement |
	anElement := aFilterViewModel asFilterLabeledElement
			id: (GtFilterNameId indexed: anIndex);
			margin: (BlInsets left: 3 right: 3);
			constraintsDo: [ :c | 
				c flow vertical alignCenter.
				c flow horizontal alignLeft ];
			when: GtFilterFocusNextFilterWish
				do: [ :anEvent | self onFocusNextFilterWish: anEvent ].

	self addNavigationShortcutsTo: anElement.
	self addRemoveButtonIconTo: anElement.

	anElement
		addShortcut: (BlShortcutWithAction new
				name: 'Remove filter';
				combination: (BlKeyCombination backspace or: BlKeyCombination delete);
				overrideChildren: false;
				action: [ :anEvent | 
					self
						onRemoveFilterViewModelOfElement: anEvent currentTarget
						from: anEvent currentTarget ]).

	self addChild: anElement at: anIndex.

	^ anElement
]

{ #category : #'private - updating' }
GtFilterItemsElement >> addItemElementForViewModel: aFilterViewModel [
	| anIndex anElement |
	anIndex := self filtersViewModel items
			detectIndex: [ :each | each == aFilterViewModel ]
			ifNone: [ ^ self ].

	anElement := self addElementForFilterViewModel: aFilterViewModel index: anIndex.
	anElement fireEvent: GtFilterFocusIntendedPartAfterAddingWish new
]

{ #category : #'private - updating' }
GtFilterItemsElement >> addNavigationShortcutsTo: anElement [
	anElement
		addShortcut: (BlShortcutWithAction new
				name: 'Move to next filter';
				description: 'Moves to the next filter. If none is found, we cycle back to the first.';
				combination: (BlKeyCombination tab or: BlKeyCombination arrowRight);
				overrideChildren: false;
				action: [ :anEvent | 
					BlFocusFinder new
						direction: BlFocusSearchDirectionForward new;
						root: self;
						referenceElement: anEvent currentTarget;
						nextFocusDo: #requestFocus ifNone: [  ] ]);
		addShortcut: (BlShortcutWithAction new
				name: 'Move to previous form item';
				description: 'Moves to the previous filter. If none is found, we cycle back to the last.';
				combination: (BlKeyCombination shiftTab or: BlKeyCombination arrowLeft);
				overrideChildren: false;
				action: [ :anEvent | 
					BlFocusFinder new
						direction: BlFocusSearchDirectionBackward new;
						root: self;
						referenceElement: anEvent currentTarget;
						nextFocusDo: #requestFocus ifNone: [  ] ]);
		addShortcut: (BlShortcutWithAction new
				name: 'Move to upper filter';
				description: 'Moves to the upper filter. If none is found, we stay in the current.';
				combination: (BlKeyCombination arrowUp);
				overrideChildren: false;
				action: [ :anEvent | 
					BlFocusFinder new
						up;
						root: self;
						referenceElement: anEvent currentTarget;
						nextFocusDo: #requestFocus ifNone: [  ] ]);
		addShortcut: (BlShortcutWithAction new
				name: 'Move to lower filter';
				description: 'Moves to the lower filter. If none is found, we stay in the current.';
				combination: (BlKeyCombination arrowDown);
				overrideChildren: false;
				action: [ :anEvent | 
					BlFocusFinder new
						down;
						root: self;
						referenceElement: anEvent currentTarget;
						nextFocusDo: #requestFocus ifNone: [  ] ]);
		addShortcut: (BlShortcutWithAction new
				name: 'Edit filter';
				combination: BlKeyCombination enter;
				overrideChildren: false;
				action: [ :anEvent | self onEditItemsEvent: anEvent ])
]

{ #category : #'private - updating' }
GtFilterItemsElement >> addNewFilterElement [
	self addChild: self newAddFilterButton as: GtFiltersAddId
]

{ #category : #'private - updating' }
GtFilterItemsElement >> addRemoveButtonIconTo: anElement [
	| aRemoveButton aKeyMap |
	aKeyMap := 'Backspace | Delete'.
	anElement clipChildren: false.
	aRemoveButton := self newRemoveButton.
	aRemoveButton visibility: BlVisibility gone.
	aRemoveButton addAptitude: (BrGlamorousWithLabelTooltipAptitude 
		text: 'Remove' 
		keymap: aKeyMap).
	aRemoveButton action: [ :aButton |
		self onRemoveFilterViewModelOfElement: anElement from: aButton ].
	anElement
		when: BlMouseEnterEvent
		do: [ :anEvent | aRemoveButton visibility: BlVisibility visible ].
	anElement
		when: BlMouseLeaveEvent
		do: [ :anEvent | aRemoveButton visibility: BlVisibility gone ].
	anElement addChild: aRemoveButton
]

{ #category : #'private - updating' }
GtFilterItemsElement >> availableFilters [
	^ self hasFiltersViewModel
		ifTrue: [ self filtersViewModel availableFilters
				ifEmpty: [ {GtFilterVirtualEmptyModel default} ] ]
		ifFalse: [ {GtFilterVirtualEmptyModel default} ]
]

{ #category : #'private - updating' }
GtFilterItemsElement >> createDropdownContent [
	| aListElement |
	aListElement := BrSimpleList new.
	^ aListElement
		vFitContentLimited;
		hFitContentLimited;
		constraintsDo: [ :c | 
			c maxHeight: 100 ];
		itemStencil: [ :anItemType | self createItemElementForListElement: aListElement ];
		itemDataBinder: [ :anItemElement :anItemObject :anItemIndex | 
			anItemElement id: (GtFilterItemId indexed: anItemIndex).
			anItemElement userData at: GtFilterModel put: anItemObject.
			(anItemElement childAt: 1) text: anItemObject name.
			anItemElement ];
		itemDataUnbinder: [ :anItemElement :anItemObject :anItemIndex | 
			anItemElement id: nil.
			anItemElement userData removeKey: GtFilterModel ifAbsent: [ "ignore" ].
			(anItemElement childAt: 1) text: ''.
			anItemElement ];
		when: BlElementAddedToSceneGraphEvent
			do: [ :anEvent | self onListElementAddedToSceneGraph: anEvent ];
		addShortcut: (BlShortcutWithAction new
				name: 'Add selected filter';
				description: 'Add selected filter';
				combination: BlKeyCombination builder enter build;
				action: [ :aShortcutEvent :aShortcut | self onAddSelectedItemEvent: aShortcutEvent ]);
		withAsyncFutureDo: [ :anElementFuture |
			anElementFuture
				whenPending: [ :theListElement | 
					theListElement items: { GtFilterVirtualWaitingModel default }  ];
				whenError: [ :theListElement :anError |
					theListElement items: { GtFilterVirtualExceptionModel new exception: anError } ];
				whenSuccess: [ :theListElement :aCollection |
					theListElement items: aCollection ];
				future: [ self availableFilters ] asAsyncFuture ] 
]

{ #category : #'private - updating' }
GtFilterItemsElement >> createItemElementForListElement: aListElement [
	self
		assert: [ aListElement isNotNil ]
		description: [ 'List element must be non-nil' ].
		
	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 5);
		addAptitude: (BrStyleCommonAptitude new
				default: [ :s | s background: Color transparent ];
				hovered: [ :s | s background: self theme button defaultBorderColor ];
				selected: [ :s | s background: self theme button defaultBorderColor ]);
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize);
		when: BlClickEvent do: [ :anEvent | self onItemMouseClickEvent: anEvent ];
		when: BlMouseEnterEvent
			do: [ :anEvent | self onItemMouseEnterEvent: anEvent listElement: aListElement ]
]

{ #category : #initialization }
GtFilterItemsElement >> defaultLayout [
	^ BlFlowLayout horizontal
]

{ #category : #'event handling' }
GtFilterItemsElement >> focusFirstItemElementInList: aListElement [
	aListElement requestFocus.
	aListElement selectFirst.
	aListElement scrollToSelection
]

{ #category : #initialization }
GtFilterItemsElement >> initialize [
	super initialize.
	self hFitContentLimited.
	self vFitContent.
	self padding: (BlInsets  top: 5 right: 2 bottom: 2 left: 1).
	self clipChildren: false.
	self initializeEventHandlers.
	self initializeShortcuts.
]

{ #category : #initialization }
GtFilterItemsElement >> initializeEventHandlers [
	
]

{ #category : #initialization }
GtFilterItemsElement >> initializeShortcuts [
	self
		addShortcut: (BlShortcutWithAction new
				name: 'Add new filter';
				combination: (BlKeyCombination builder
						shift;
						primary;
						s;
						build);
				action: [ :anEvent | self onAddNewFilterShortcutEvent: anEvent ])
]

{ #category : #'private - updating' }
GtFilterItemsElement >> newAddFilterButton [
	^ self newAddFilterHandleElement
		id: GtFiltersAddButtonId;
		addAptitude: BrGlamorousButtonWithLabelTooltipAptitude new;
		addAptitude: (BrStyleCommonAptitude new
			default: [ :aStyle | 
				aStyle
					border: BlBorder empty;
					background: self theme status neutralBackgroundColor ];
			hovered: [ :aStyle | 
				aStyle background: self theme status neutralBackgroundColor darker ];
			pressed: [ :aStyle | 
				aStyle background: self theme status neutralBackgroundColor darker darker ];
			focused: [ :aStyle | 
				aStyle border: (BlBorder paint: self theme editor focusedBorderColor width: 1) ]);
		addAptitude: (BrGlamorousWithDropdownAptitude
			handle: [ self newAddFilterHandleElement ]
			content: [ self createDropdownContent ])
				beNotResizable;
		margin: (BlInsets left: 2);
		constraintsDo: [ :c | c flow vertical alignCenter ];
		beFocusable;
		in: [ :anElement | self addNavigationShortcutsTo: anElement ];
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | anEvent currentTarget dispatchEvent: BrDropdownShowWish new ]);
		when: BrDropdownIsHidden
			do: [ :anEvent | self onAddFilterDropdownIsHiddenEvent: anEvent ];
		when: GtFilterEditWish
			do: [ :anEvent | anEvent currentTarget dispatchEvent: BrDropdownShowWish new ]
]

{ #category : #'private - updating' }
GtFilterItemsElement >> newAddFilterHandleElement [
	^ BrButton new
		aptitude: BrGlamorousButtonRectangularAptitude new;
		addAptitude: BrGlamorousButtonIconAptitude new;
		icon: BrGlamorousVectorIcons add;
		label: 'Add Filter';
		beSmallSize;
		hExact: 20
]

{ #category : #'private - updating' }
GtFilterItemsElement >> newRemoveButton [
	^ GtInspectorRoundButtonStencil mini asElement
		icon: (BrPlusIconStencil close radius: 3) asElement;
		zIndex: 10;
		id: GtPagerClosePageButtonElementId;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignCenterAt: 1.0.
			c ignored vertical alignCenterAt: 0.0 ]
]

{ #category : #'private - updating' }
GtFilterItemsElement >> onAddFilterDropdownIsHiddenEvent: anEvent [
	anEvent currentTarget requestFocus
]

{ #category : #'event handling' }
GtFilterItemsElement >> onAddNewFilterShortcutEvent: anEvent [
	self hasChildren ifFalse: [ ^ self ].
	anEvent consumed: true.
	self children last
		requestFocus;
		dispatchEvent: GtFilterEditWish new
]

{ #category : #'event handling' }
GtFilterItemsElement >> onAddSelectedItemEvent: aShortcutEvent [
	| anElementList |
	anElementList := aShortcutEvent currentTarget.
	anElementList
		selectedItemDo: [ :aFilterModel :anIndex | 
			BlTaskAction
				enqueueElement: self
				action: [ anElementList fireEvent: BrDropdownHideWish new ].
			BlTaskAction
				enqueueElement: self
				action: [ self requestAddFilterModel: aFilterModel ] ] 
]

{ #category : #'event handling' }
GtFilterItemsElement >> onEditItemsEvent: anEvent [ 
	anEvent currentTarget dispatchEvent: GtFilterEditWish new
]

{ #category : #'api - filter view model' }
GtFilterItemsElement >> onFiltersViewModelChanged [
	self updateItemsElement
]

{ #category : #'event handling' }
GtFilterItemsElement >> onFocusNextFilterWish: anEvent [
	anEvent consumed: true.
	BlTaskAction enqueueElement: self action: [
		GtFilterExcludingFocusFinder new
			direction: BlFocusSearchDirectionForward new;
			root: self;
			referenceElement: anEvent currentTarget;
			excludedElement: anEvent currentTarget;
			nextFocusDo: [ :anElement | 
				anElement requestFocus ] ifNone: [  ] ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> onItemAdded: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self addItemElementForViewModel: anAnnouncement item ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> onItemMouseClickEvent: anEvent [
	| aModel |
	anEvent consumed: true.
	anEvent currentTarget fireEvent: BrDropdownHideWish new.
	aModel := anEvent currentTarget userData at: GtFilterModel ifAbsent: [ nil ].
	self requestAddFilterModel: aModel
]

{ #category : #'event handling' }
GtFilterItemsElement >> onItemMouseEnterEvent: anEvent listElement: aListElement [
	"Select the hovered item"

	| anItemElement aFilter |
	anItemElement := anEvent currentTarget.
	aFilter := anItemElement userData at: GtFilterModel ifAbsent: [ nil ].
	aFilter ifNil: [ ^ self ].
	aListElement
		itemSuchThat: [ :eachItem | eachItem == aFilter ]
		do: [ :anIndex | aListElement selectOne: anIndex ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> onItemRemoved: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self removeItemElementForViewModel: anAnnouncement item ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> onItemsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateItemsElement ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> onListElementAddedToSceneGraph: anEvent [
	self focusFirstItemElementInList: anEvent currentTarget
]

{ #category : #'private - updating' }
GtFilterItemsElement >> onRemoveFilterViewModelOfElement: anElement from: aButton [ 
	anElement hasFilterViewModel ifFalse: [ ^ self ].
	self hasFiltersViewModel ifFalse: [ ^ self ].
	
	self filtersViewModel removeFilterViewModel: anElement filterViewModel
]

{ #category : #'event handling' }
GtFilterItemsElement >> onRemoveFilterViewModelWish: anEvent [ 
	anEvent filterViewModel ifNil: [ ^ self ].
	self hasFiltersViewModel ifFalse: [ ^ self ].
	
	self filtersViewModel removeFilterViewModel: anEvent filterViewModel
]

{ #category : #'private - updating' }
GtFilterItemsElement >> removeItemElementForViewModel: aFilterViewModel [
	| aChildToFocus |
	aChildToFocus := nil.
	self
		childrenDo: [ :aChild | 
			((aChild id = GtFiltersAddButtonId uniqueInstance) not
				and: [ aChild filterViewModel == aFilterViewModel ])
				ifTrue: [ | isChildFocused |
					isChildFocused := aChild isFocused.
					aChild removeFromParent.
					isChildFocused
						ifTrue: [ aChildToFocus
								ifNotNil: [ aChildToFocus requestFocus ]
								ifNil: [ self
										childrenDo: [ :anotherChild | 
											anotherChild requestFocus.
											^ self ] ] ].
					^ self ].
			aChildToFocus := aChild ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> requestAddFilterModel: aFilterModel [
	aFilterModel ifNil: [ ^ self ].
	aFilterModel isExceptionFilterModel ifTrue: [
		self phlow spawnObject: aFilterModel exception.
		^ self ].
	aFilterModel isVirtualFilterModel ifTrue: [ ^ self ].
	self hasFiltersViewModel ifFalse: [ ^ self ].

	self filtersViewModel addFilterModel: aFilterModel
]

{ #category : #'api - filter view model' }
GtFilterItemsElement >> subscribeToFiltersViewModel [
	self filtersViewModel weak
		when: GtFiltersViewModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFiltersViewModelItemAdded
			send: #onItemAdded:
			to: self;
		when: GtFiltersViewModelItemRemoved
			send: #onItemRemoved:
			to: self
]

{ #category : #'api - filter view model' }
GtFilterItemsElement >> unsubscribeFromFiltersViewModel [
	self filtersViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtFilterItemsElement >> updateItemsElement [
	self removeChildren.
	self filtersViewModel items withIndexDo: [ :eachFilterViewModel :anIndex | 
		self addElementForFilterViewModel: eachFilterViewModel index: anIndex ].
	self addNewFilterElement
]

{ #category : #'private - updating' }
GtFilterItemsElement >> updateItemsElementDueTo: aReason [
	self removeChildren.
	self filtersViewModel items withIndexDo: [ :eachFilterViewModel :anIndex | 
		self addElementForFilterViewModel: eachFilterViewModel index: anIndex ].
	self addNewFilterElement
]
