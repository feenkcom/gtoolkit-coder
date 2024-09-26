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
GtFilterShortListSettingsElement >> defaultItemLabel [
	^ 'item'
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
			aptitude: BrGlamorousButtonWithLabelAptitude
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
					label: anItemObject label;
					model: anItemObject ];
			itemDataUnbinder: [ :anItemElement :anItemObject :anItemIndex | 
				anItemElement
					label: self defaultItemLabel;
					model: nil ].

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
		addAptitude: BrGlamorousButtonLabelAptitude.
		
	self updateHandleElement: aHandle.
	handleElement at: 1 put: aHandle.
	^ aHandle
]

{ #category : #initialization }
GtFilterShortListSettingsElement >> newItemElement [
	^ self newButtonElement
		aptitude: BrGlamorousButtonRectangularAptitude;
		addAptitude: BrGlamorousButtonLabelAptitude;
		label: 'item';
		action: [ :aButton | self onItemClick: aButton ]
]

{ #category : #'api - filter view model' }
GtFilterShortListSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.
	self updateElement
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onItemClick: aButton [
	self hasFilterViewModel ifFalse: [ ^ self ].
	aButton fireEvent: BrDropdownHideWish new.

	self filterViewModel selectedItem: aButton model
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onItemsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'event handling' }
GtFilterShortListSettingsElement >> onSelectedItemChanged: anAnnouncement [.
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - filter view model' }
GtFilterShortListSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.
	self filterViewModel weak
		when: GtFilterShortListViewModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterShortListViewModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateButtonElement [
	buttonElement label: self filterViewModel selectedItem label
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

	anElement label: self filterViewModel selectedItem label
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElement [
	| aHeight aWidth |
	aHeight := self filterViewModel itemsCount * 12.
	aWidth := (self filterViewModel items detectMax: #labelSize)
			ifNotNil: [ :anItem | anItem labelSize * 12 ]
			ifNil: [ 30 ].
	buttonAptitude preferredExtent: aHeight @ aWidth.

	self listElementDo: [ :anElement | self updateListElement: anElement ]
]

{ #category : #'private - updating' }
GtFilterShortListSettingsElement >> updateListElement: anElement [
	self hasFilterViewModel ifFalse: [ ^ self ].

	anElement items: self filterViewModel itemsWithoutSelection
]
