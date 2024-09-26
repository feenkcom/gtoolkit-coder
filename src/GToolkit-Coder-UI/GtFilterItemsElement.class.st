Class {
	#name : #GtFilterItemsElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtWithFiltersViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtWithFiltersViewModel classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'private - updating' }
GtFilterItemsElement >> addElementForFilterViewModel: aFilterViewModel [
	| anElement |
	anElement := GtFilterNameElement new filterViewModel: aFilterViewModel.
	anElement margin: (BlInsets left: 3 right: 3).
	anElement
		constraintsDo: [ :c | 
			c flow vertical alignCenter.
			c flow horizontal alignLeft ].
			
	self addNavigationShortcutsTo: anElement.

	self addChild: anElement
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
						nextFocusDo: #requestFocus ifNone: [  ] ]).
]

{ #category : #'private - updating' }
GtFilterItemsElement >> addNewFilterElement [
	self addChild: self newAddFilterButton as: #add
]

{ #category : #'private - updating' }
GtFilterItemsElement >> createDropdownContent [
	^ BrSimpleList new
		vFitContentLimited;
		hFitContentLimited;
		constraintsDo: [ :c | 
			c maxHeight: 200 ];
		stencil: [ :eachFilterModel :eachIndex | 
			BrHorizontalPane new
				id: (GtFilterTagPickerItemId indexed: eachIndex);
				hMatchParent;
				vFitContent;
				padding: (BlInsets all: 5);
				addAptitude: (BrStyleCommonAptitude new
					default: [ :s | s background: Color transparent ];
					hovered: [ :s | s background: self theme button defaultBorderColor ];
					yourself);
				when: BlClickEvent
					do: [ :anEvent |
						anEvent consumed: true.
						anEvent currentTarget fireEvent: BrDropdownHideWish new.
						self requestAddFilterModel: eachFilterModel ];
				addChild: (BrLabel new
					aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
					text: eachFilterModel label;
					yourself);
				yourself ];
		items: (self hasFiltersViewModel 
			ifTrue: [ self filtersViewModel availableFilters ] 
			ifFalse: [ #() ]);
		yourself
]

{ #category : #initialization }
GtFilterItemsElement >> defaultLayout [
	^ BlFlowLayout horizontal
]

{ #category : #initialization }
GtFilterItemsElement >> initialize [
	super initialize.
	self hFitContentLimited.
	self vFitContent.
	self padding: (BlInsets all: 2).
	self initializeEventHandlers.
]

{ #category : #initialization }
GtFilterItemsElement >> initializeEventHandlers [
	self
		when: GtFilterRemoveFilterViewModelWish
		do: [ :anEvent | self onRemoveFilterViewModelWish: anEvent ]
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
			content: [ self createDropdownContent ]);
		margin: (BlInsets left: 2);
		constraintsDo: [ :c | c flow vertical alignCenter ];
		beFocusable;
		in: [ :anElement | self addNavigationShortcutsTo: anElement ];
		addShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | anEvent currentTarget dispatchEvent: BrDropdownShowWish new ])
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

{ #category : #'api - filter view model' }
GtFilterItemsElement >> onFiltersViewModelChanged [
	self updateItemsElement
]

{ #category : #'event handling' }
GtFilterItemsElement >> onItemsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateItemsElement ]
]

{ #category : #'event handling' }
GtFilterItemsElement >> onRemoveFilterViewModelWish: anEvent [ 
	anEvent filterViewModel ifNil: [ ^ self ].
	self hasFiltersViewModel ifFalse: [ ^ self ].
	
	self filtersViewModel removeFilterViewModel: anEvent filterViewModel
]

{ #category : #'event handling' }
GtFilterItemsElement >> requestAddFilterModel: aFilterModel [
	self hasFiltersViewModel ifFalse: [ ^ self ].

	self filtersViewModel addFilterModel: aFilterModel
]

{ #category : #'api - filter view model' }
GtFilterItemsElement >> subscribeToFiltersViewModel [
	self filtersViewModel weak
		when: GtFiltersViewModelItemsChanged
		send: #onItemsChanged:
		to: self
]

{ #category : #'api - filter view model' }
GtFilterItemsElement >> unsubscribeFromFiltersViewModel [
	self filtersViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtFilterItemsElement >> updateItemsElement [
	self removeChildren.
	self filtersViewModel items do: [ :eachFilterViewModel | 
		self addElementForFilterViewModel: eachFilterViewModel ].
	self addNewFilterElement
]
