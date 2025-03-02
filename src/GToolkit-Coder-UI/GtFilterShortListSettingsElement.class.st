Class {
	#name : #GtFilterShortListSettingsElement,
	#superclass : #GtFilterSettingsElement,
	#instVars : [
		'buttonElement',
		'buttonAptitude',
		'listElement',
		'handleElement'
	],
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterShortListSettingsElement >> defaultItemIcon [
	^ BrFrame new exact: 0 @ 0
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> defaultItemLabel [
	^ ''
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> dispatchShowItemsWish [
	buttonElement dispatchEvent: BrDropdownShowWish new
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> focusFirstItemElementInList: aListElement [
	aListElement requestFocus.
	aListElement selectFirst.
	aListElement selectedItemDo: [ :anItem | 
		(self filterViewModel selectedItem = anItem)
			ifTrue: [ aListElement selectNext ] ].
	aListElement scrollToSelection
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> handleElementDo: aBlock [
	(handleElement at: 1) ifNotNil: aBlock
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> initialize [
	super initialize.
	handleElement := nil asWeakReference.
	listElement := nil asWeakReference.
	self initializeButtonElement.
	self addChild: buttonElement as: #button.
	self initializeEventHandlers.
	self initializeShortcuts.
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> initializeButtonElement [
	buttonElement := self newButtonElement
			aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
			addAptitude: BrGlamorousButtonIconDropdownAptitude;
			addAptitude: (BrGlamorousWithExplicitDropdownAptitude
				handle: [ self newHandleElement ]
				content: [ self newContentElement ]
				do: [ :theAptitude |
					theAptitude
						withContainerDownUpDropdown;
						when: BrDropdownIsHidden
						do: [ :anEvent | self onDropdownIsHiddenEvent: anEvent ] ])
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> initializeEventHandlers [
	self when: GtFilterEditWish do: [ :anEvent | self onEditWish: anEvent ]
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> initializeShortcuts [
	self
		addShortcut: (BlShortcutWithAction new
				name: 'Display items';
				combination: (BlKeyCombination space or: BlKeyCombination enter);
				overrideChildren: false;
				action: [ :anEvent | self onDisplayItemsEvent: anEvent ])
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> interruptListElementFuture [
	self listElementDo: [ :anElement | 
		anElement withAsyncFutureDo: [ :anElementFuture | 
			anElementFuture 
				cancelHard;
				interrupt ] ]
]

{ #category : #accessing }
GtFilterShortListSettingsElement >> listElementDo: aBlock [
	(listElement at: 1) ifNotNil: aBlock
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> newButtonElement [
	^ BrButton new
		beSmallSize;
		label: self defaultItemLabel;
		icon: self defaultItemIcon;
		fitContent
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> newContentElement [
	| aListElement |
	self
		listElementDo: [ :anElement | 
			anElement removeFromParent.
			^ anElement ].

	aListElement := BrSimpleList new
			fitContentLimited;
			itemStencil: [ :anItemType :aListWidget | self newItemElement ];
			itemDataBinder: [ :anItemElement :anItemObject :anItemIndex | 
				anItemElement disabled: (anItemObject isVirtualFilterModelItem or: [ 
					anItemObject = self filterViewModel selectedItem ]).
				anItemElement
					label: (anItemObject label ifNil: [ self defaultItemLabel ]);
					icon: (anItemObject icon ifNil: [ self defaultItemIcon ]);
					id: (GtFilterItemId indexed: anItemIndex);
					model: anItemObject ];
			itemDataUnbinder: [ :anItemElement :anItemObject :anItemIndex | 
				anItemElement
					label: self defaultItemLabel;
					icon: self defaultItemIcon;
					id: nil;
					model: nil ];
			withAsyncFutureDo: [ :anElementFuture |
				anElementFuture
					executionConfiguration: (AsyncFutureExecutionConfiguration new 
						customGroup: #CoderFilter;
						lowPriority);
					whenPending: [ :theListElement |
						theListElement items: { GtFilterModelComputingItem default } ];
					whenError: [ :theListElement :anError | 
						theListElement items: { (GtFilterModelExceptionItem freeze: anError) } ];
					whenSuccess: [ :theListElement :aCollection |
						self updateListElement: theListElement items: aCollection ] ];
			when: BlElementAddedToSceneGraphEvent
				do: [ :anEvent | self onListElementAddedToSceneGraph: anEvent ];
			addShortcut: (BlShortcutWithAction new
					name: 'Pick selected filter item';
					description: 'Pick selected item as the filter selected item';
					combination: BlKeyCombination builder enter build;
					action: [ :aShortcutEvent :aShortcut | self onPickSelectedItemEvent: aShortcutEvent ]);
			addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder arrowDown build;
				action: [ self selectNextItemInList: aListElement ]);
			addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder arrowUp build;
				action: [ self selectPreviousItemInList: aListElement ])";
			addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary home build;
				action: [ self selectFirst; scrollToSelection ]);
			addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary end build;
				action: [ self selectLast; scrollToSelection ] )".

				
	aListElement finalizationRegistry
		add: aListElement
		finalizer: (ObjectFinalizer new
			receiver: self;
			selector: #onListElementFinalization;
			arguments: #()).
				
	self updateListElement: aListElement.
	listElement at: 1 put: aListElement.
	^ aListElement
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> newHandleElement [
	| aHandle |
	self
		handleElementDo: [ :anElement | 
			anElement removeFromParent.
			^ anElement ].
	aHandle := self newButtonElement
		disable;
		aptitude: BrGlamorousButtonRectangularAptitude;
		addAptitude: BrGlamorousButtonIconAptitude;
		addAptitude: BrGlamorousButtonLabelAptitude;
		addAptitude: BrGlamorousButtonIconDropdownAptitude.
		
	self updateHandleElement: aHandle.
	handleElement at: 1 put: aHandle.
	^ aHandle
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> newItemElement [
	^ self newButtonElement
		aptitude: BrGlamorousButtonRectangularAptitude;
		addAptitude: BrGlamorousButtonIconAptitude;
		addAptitude: BrGlamorousButtonLabelAptitude;
		hMatchParent;
		alignCenterLeft;
		label: 'item';
		action: [ :aButton | self onItemClick: aButton ];
		when: BlMouseEnterEvent
			do: [ :anEvent | self onItemMouseEnterEvent: anEvent ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onDisplayItemsEvent: anEvent [
	anEvent consumed: true.
	self dispatchShowItemsWish
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onDropdownIsHiddenEvent: anEvent [
	self fireEvent: GtFilterFocusWholeWish new
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onEditWish: anEvent [
	anEvent consumed: true.
	self dispatchShowItemsWish
]

{ #category : #'api - filter view model' }
GtFilterShortListSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.
	self updateElement
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onFiltersViewModelItemRemoved: anAnnouncement [
	self interruptListElementFuture
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onItemClick: aButton [
	self hasFilterViewModel ifFalse: [ ^ self ].
	self updateSelectedItem: aButton model from: aButton.
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onItemMouseEnterEvent: anEvent [
	"Select the hovered item"

	| aButton aFilterItem |
	aButton := anEvent currentTarget.
	aFilterItem := aButton model.
	aFilterItem ifNil: [ ^ self ].
	self
		listElementDo: [ :aListElement | 
			aListElement
				itemSuchThat: [ :eachItem | eachItem == aFilterItem ]
				do: [ :anIndex | aListElement selectOne: anIndex ] ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onItemsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onListElementAddedToSceneGraph: anEvent [
	self focusFirstItemElementInList: anEvent currentTarget
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onListElementFinalization [
	self interruptListElementFuture
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onPickSelectedItemEvent: aShortcutEvent [
	| anElementList |
	anElementList := aShortcutEvent currentTarget.
	anElementList selectedItemDo: [ :anItem :anIndex | 
		self updateSelectedItem: anItem from: anElementList ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onSelectedItemChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> selectNextItemInList: aListElement [ 
	| aCurrentSelection |
	aCurrentSelection := aListElement selectedIndices.
	aListElement selectNext.
	aListElement selectedItemDo: [ :anItem | 
		(self filterViewModel selectedItem = anItem)
			ifTrue: [ aListElement selectNext ] ].
	aListElement selectedItemDo: [ :anItem | 
		(self filterViewModel selectedItem = anItem)
			ifTrue: [ 
				aListElement selectPrevious. 
				^ self ] ].
	
	aListElement scrollToSelection 
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> selectPreviousItemInList: aListElement [ 
	| aCurrentSelection |
	aCurrentSelection := aListElement selectedIndices.
	aListElement selectPrevious.
	aListElement selectedItemDo: [ :anItem | 
		(self filterViewModel selectedItem = anItem)
			ifTrue: [ aListElement selectPrevious ] ].
	aListElement selectedItemDo: [ :anItem | 
		(self filterViewModel selectedItem = anItem)
			ifTrue: [ 
				aListElement selectNext. 
				^ self ] ].
	
	aListElement scrollToSelection 
]

{ #category : #'api - filter view model' }
GtFilterShortListSettingsElement >> subscribeToFilterViewModel [
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
GtFilterShortListSettingsElement >> updateButtonElement [
	self updateHandleElement: buttonElement
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateElement [
	self updateButtonElement.
	self updateHandleElement.
	self updateListElement.
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateHandleElement [
	self handleElementDo: [ :anElement | 
		self updateHandleElement: anElement ].
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateHandleElement: anElement [
	self hasFilterViewModel ifFalse: [ ^ self ].

	self filterViewModel selectedItem
		ifIconAndLabel: [ :anIcon :aLabel | 
			anElement icon: anIcon.
			anElement label: aLabel ]
		ifIcon: [ :anIcon | 
			anElement icon: anIcon.
			anElement label: self defaultItemLabel ]
		ifLabel: [ :aLabel | 
			anElement icon: self defaultItemIcon.
			anElement label: aLabel ]
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElement [
	self listElementDo: [ :anElement | self updateListElement: anElement ]
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElement: anElement [
	self hasFilterViewModel ifFalse: [ ^ self ].
	
	anElement withAsyncFutureDo: [ :anElementFuture |
		anElementFuture future: self filterViewModel someItemsFuture asAsyncFuture ].
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElement: theListElement items: aCollection [
	aCollection
		ifEmpty: [ theListElement items: {GtFilterModelEmptyItem default} ]
		ifNotEmpty: [ theListElement items: aCollection ]
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElementOldWay: anElement [
	"We use this method to demo a UI blocking issue.
	See https://github.com/feenkcom/gtoolkit/issues/4327"

	| aCollection |
	self hasFilterViewModel ifFalse: [ ^ self ].

	aCollection := self filterViewModel someItems.
	self updateListElement: anElement items: aCollection
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateSelectedItem: aFilterModelItem from: anElement [
	aFilterModelItem ifNil: [ ^ self ].
	aFilterModelItem isVirtualFilterModelItem ifTrue: [ ^ self ].
	aFilterModelItem isExceptionFilterModelItem ifTrue: [
		anElement phlow spawnObject: aFilterModelItem.
		^ self ].
	
	self hasFilterViewModel ifFalse: [ ^ self ].
	aFilterModelItem = self filterViewModel selectedItem ifTrue: [ ^ self ].
	BlTaskAction
		enqueueElement: self
		action: [ anElement fireEvent: BrDropdownHideWish new ].
	BlTaskAction
		enqueueElement: self
		action: [ self filterViewModel selectedItem: aFilterModelItem ]
]
