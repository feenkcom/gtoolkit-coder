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

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> focusFirstItemElementInList: aListElement [
	aListElement requestFocus.
	aListElement selectFirst.
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
	self initializeDropdownAptitude.
	buttonElement addAptitude: buttonAptitude.
	self addChild: buttonElement as: #button
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> initializeButtonElement [
	buttonElement := self newButtonElement
			aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
			addAptitude: BrGlamorousButtonIconDropdownAptitude
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> initializeDropdownAptitude [
	buttonAptitude := BrGlamorousWithDropdownAptitude
			handle: [ self newHandleElement ]
			content: [ self newContentElement ].
	buttonAptitude beNotResizable.
]

{ #category : #initialization }
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
			when: BlElementAddedToSceneGraphEvent
				do: [ :anEvent | self onListElementAddedToSceneGraph: anEvent ];
			addShortcut: (BlShortcutWithAction new
					name: 'Pick selected filter item';
					description: 'Pick selected item as the filter selected item';
					combination: BlKeyCombination builder enter build;
					action: [ :aShortcutEvent :aShortcut | self pickSelectedItem: aShortcutEvent ]).

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

{ #category : #'api - filter view model' }
GtFilterShortListSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.
	self updateElement
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onItemClick: aButton [
	self hasFilterViewModel ifFalse: [ ^ self ].
	BlTaskAction
		enqueueElement: self
		action: [ aButton fireEvent: BrDropdownHideWish new ].
	BlTaskAction
		enqueueElement: self
		action: [ self filterViewModel selectedItem: aButton model ]
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
	BlTaskAction
		enqueueElement: anEvent currentTarget
		action: [ self focusFirstItemElementInList: anEvent currentTarget ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onSelectedItemChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> pickSelectedItem: aShortcutEvent [
	| anElementList |
	anElementList := aShortcutEvent currentTarget.
	anElementList
		selectedItemDo: [ :anItem :anIndex | 
			BlTaskAction
				enqueueElement: self
				action: [ anElementList fireEvent: BrDropdownHideWish new ].
			BlTaskAction
				enqueueElement: self
				action: [ self filterViewModel selectedItem: anItem ] ]
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
			to: self
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateButtonElement [
	self updateHandleElement: buttonElement
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateElement [
	self updateButtonElement.
	self updateHandleElement.
	self updateListElement
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
	| aHeight aWidth anExtent |
	aHeight := self filterViewModel items size.
	aWidth := self filterViewModel items
		inject: 3
		into: [ :aMax :each | 
			aMax > each labelSize 
				ifTrue: [ aMax ] 
				ifFalse: [ each labelSize ] ].
	anExtent := (aWidth * 12) @ (aHeight * 12).
	
	buttonAptitude preferredExtent: anExtent.

	self listElementDo: [ :anElement | self updateListElement: anElement ]
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElement: anElement [
	self hasFilterViewModel ifFalse: [ ^ self ].

	anElement items: self filterViewModel itemsWithoutSelection
]
