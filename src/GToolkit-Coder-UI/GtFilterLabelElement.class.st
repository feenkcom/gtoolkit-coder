Class {
	#name : #GtFilterLabelElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtWithFilterViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtWithFilterViewModel classTrait',
	#instVars : [
		'labelElement',
		'settingsContainer'
	],
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'private - updating' }
GtFilterLabelElement >> addSettingsElement: anElement [
	settingsContainer addChild: anElement as: GtFilterSettingsId
]

{ #category : #initialization }
GtFilterLabelElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtFilterLabelElement >> initialize [
	super initialize.
	self fitContent.
	self beFocusable.
	self beInSingleCompositionLayer.

	self initializeLabelElement.
	self initializeSettingsContainer.

	self initializeStyling.
	self initializeEventHandlers.
	self initializeShortcuts
]

{ #category : #initialization }
GtFilterLabelElement >> initializeEventHandlers [
	self when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].
	self when: GtFilterEditWish do: [ :anEvent | self onEditWish: anEvent ].
	self when: GtFilterFocusIntendedPartAfterAddingWish do: [ :anEvent | 
		self onFocusFirstPartWish: anEvent ].
	self when: GtFilterFocusWholeWish do: [ :anEvent | self onFocusWholeWish: anEvent ].
	self when: GtFilterFocusNextPartWish do: [ :anEvent | self onFocusNextPartdWish: anEvent ]
]

{ #category : #initialization }
GtFilterLabelElement >> initializeLabelElement [
	labelElement := BrLabel new
			id: GtFilterTagLabelId;
			text: 'Filter';
			aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
			vFitContent;
			beSmallSize;
			constraintsDo: [ :c | c linear vertical alignCenter ]
]

{ #category : #initialization }
GtFilterLabelElement >> initializeSettingsContainer [
	settingsContainer := BrHorizontalPane new
			hFitContentLimited;
			vFitContent;
			margin: (BlInsets all: 2);
			constraintsDo: [ :c | 
				c linear vertical alignCenter.
				c minHeight: 20 ]
]

{ #category : #initialization }
GtFilterLabelElement >> initializeShortcuts [
	
]

{ #category : #initialization }
GtFilterLabelElement >> initializeStyling [
	self
		addAptitude: (BrStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
					aStyle background: self theme status neutralBackgroundColor ];
				hovered: [ :aStyle | aStyle background: self theme status neutralBackgroundColor darker ];
				focused: [ :aStyle | aStyle background: self theme editor focusedBorderColor lighter lighter ]).

	self
		addAptitude: (BrStyleCommonAptitude new
				// GtFilterTagLabelId / #label;
				default: [ :aStyle | aStyle foreground: Color black ];
				focused: [ :aStyle | aStyle foreground: Color white ])
]

{ #category : #'event handling' }
GtFilterLabelElement >> onClickEvent: anEvent [
	anEvent consumed: true.
	anEvent modifiers isSoftAltOnly ifFalse: [
		self requestFocus.
		^ self ].
	
	GtFilterMethodDefinitionSpawner new
		filterElement: self;
		spawn
]

{ #category : #'event handling' }
GtFilterLabelElement >> onEditWish: anEvent [
	self
		settingsElementDo: [ :anElement | anElement dispatchEvent: GtFilterEditWish new ]
]

{ #category : #'api - filter view model' }
GtFilterLabelElement >> onFilterViewModelChanged [
	self updateElement
]

{ #category : #'event handling' }
GtFilterLabelElement >> onFocusFirstPartWish: anEvent [
	anEvent consumed: true.
	self
		settingsElementDo: [ :aSettingsElement | 
			| aWish |
			aWish := GtFilterFocusFirstPartWish new.
			aSettingsElement dispatchEvent: aWish.
			aWish isConsumed ifFalse: [ self requestFocus ] ].

	true ifTrue: [ ^ self ].
	self requestFocus.
	BlTaskAction
		enqueueElement: self
		action: [ BlFocusFinder new
				right;
				root: settingsContainer;
				referenceElement: settingsContainer;
				nextFocusDo: [ :anElement | anElement requestFocus ]
					ifNone: [ self requestFocus ] ]
]

{ #category : #'event handling' }
GtFilterLabelElement >> onFocusNextPartdWish: anEvent [
	anEvent consumed: true.
	self requestFocus.
	self fireEvent: GtFilterFocusNextFilterWish new
]

{ #category : #'event handling' }
GtFilterLabelElement >> onFocusWholeWish: anEvent [
	anEvent consumed: true.
	self requestFocus
]

{ #category : #'event handling' }
GtFilterLabelElement >> onLabelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateLabelElement ]
]

{ #category : #'private - updating' }
GtFilterLabelElement >> removeSettingsElement [
	settingsContainer removeChildren
]

{ #category : #accessing }
GtFilterLabelElement >> settingsElementDo: aBlock [
	| aChild |
	aChild := settingsContainer children at: 1 ifAbsent: [ ^ self ].
	aBlock cull: aChild
]

{ #category : #'api - filter view model' }
GtFilterLabelElement >> subscribeToFilterViewModel [
	self filterViewModel weak
		when: GtFilterViewModelLabelChanged
		send: #onLabelChanged:
		to: self
]

{ #category : #'api - filter view model' }
GtFilterLabelElement >> unsubscribeFromFilterViewModel [
	self filterViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtFilterLabelElement >> updateElement [
	self updateLabelElement.
	self updateSettingsContainer.
]

{ #category : #'private - updating' }
GtFilterLabelElement >> updateLabelElement [
	labelElement text: self filterViewModel label
]

{ #category : #'private - updating' }
GtFilterLabelElement >> updateSettingsContainer [
	| anElement |
	self removeSettingsElement.
	anElement := self filterViewModel asUserSettingsElement.
	anElement ifNil: [ ^ self ].
	anElement constraintsDo: [ :c | 
		c linear vertical alignCenter.
		c frame vertical alignCenter ].
	self addSettingsElement: anElement
]
