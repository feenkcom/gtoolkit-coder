Class {
	#name : #GtFilterNameElement,
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
GtFilterNameElement >> addSettingsElement: anElement [
	settingsContainer addChild: anElement as: GtFilterSettingsId
]

{ #category : #initialization }
GtFilterNameElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtFilterNameElement >> initialize [
	super initialize.
	self fitContent.
	self beFocusable.
	self beInSingleCompositionLayer.
	self padding: (BlInsets top: 0 right: 0 bottom: 0 left: 2).

	self initializeLabelElement.
	self initializeSettingsContainer.
	self addChild: labelElement.
	self addChild: settingsContainer as: #container.

	self initializeStyling.
	self initializeEventHandlers.
	self initializeShortcuts
]

{ #category : #initialization }
GtFilterNameElement >> initializeEventHandlers [
	self when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ].
	self when: GtFilterEditWish do: [ :anEvent | self onEditWish: anEvent ].
	self when: GtFilterFocusIntendedPartAfterAddingWish do: [ :anEvent | 
		self onFocusFirstPartWish: anEvent ].
	self when: GtFilterFocusWholeWish do: [ :anEvent | self onFocusWholeWish: anEvent ].
	self when: GtFilterFocusNextPartWish do: [ :anEvent | self onFocusNextPartdWish: anEvent ]
]

{ #category : #initialization }
GtFilterNameElement >> initializeLabelElement [
	labelElement := BrLabel new
			id: GtFilterTagLabelId;
			text: 'Filter';
			aptitude: BrGlamorousLabelAptitude new glamorousRegularFont glamorousCodeSmallSize;
			vFitContent;
			beSmallSize;
			constraintsDo: [ :c | c linear vertical alignCenter ]
]

{ #category : #initialization }
GtFilterNameElement >> initializeSettingsContainer [
	settingsContainer := BrFrame new
			hFitContentLimited;
			vFitContent;
			margin: (BlInsets all: 2);
			constraintsDo: [ :c | c linear vertical alignCenter ]
]

{ #category : #initialization }
GtFilterNameElement >> initializeShortcuts [
	
]

{ #category : #initialization }
GtFilterNameElement >> initializeStyling [
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
GtFilterNameElement >> onClickEvent: anEvent [
	anEvent consumed: true.
	self requestFocus
]

{ #category : #'event handling' }
GtFilterNameElement >> onEditWish: anEvent [
	self
		settingsElementDo: [ :anElement | anElement dispatchEvent: GtFilterEditWish new ]
]

{ #category : #'api - filter view model' }
GtFilterNameElement >> onFilterViewModelChanged [
	self updateElement
]

{ #category : #'event handling' }
GtFilterNameElement >> onFocusFirstPartWish: anEvent [
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
GtFilterNameElement >> onFocusNextPartdWish: anEvent [
	anEvent consumed: true.
	self requestFocus.
	self fireEvent: GtFilterFocusNextFilterWish new
]

{ #category : #'event handling' }
GtFilterNameElement >> onFocusWholeWish: anEvent [
	anEvent consumed: true.
	self requestFocus
]

{ #category : #'event handling' }
GtFilterNameElement >> onLabelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateLabelElement ]
]

{ #category : #'private - updating' }
GtFilterNameElement >> removeSettingsElement [
	settingsContainer removeChildren
]

{ #category : #accessing }
GtFilterNameElement >> settingsElementDo: aBlock [
	| aChild |
	aChild := settingsContainer children at: 1 ifAbsent: [ ^ self ].
	aBlock cull: aChild
]

{ #category : #'api - filter view model' }
GtFilterNameElement >> subscribeToFilterViewModel [
	self filterViewModel weak
		when: GtFilterViewModelLabelChanged
		send: #onLabelChanged:
		to: self
]

{ #category : #'api - filter view model' }
GtFilterNameElement >> unsubscribeFromFilterViewModel [
	self filterViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtFilterNameElement >> updateElement [
	self updateLabelElement.
	self updateSettingsContainer.
]

{ #category : #'private - updating' }
GtFilterNameElement >> updateLabelElement [
	labelElement text: self filterViewModel label
]

{ #category : #'private - updating' }
GtFilterNameElement >> updateSettingsContainer [
	| anElement |
	self removeSettingsElement.
	anElement := self filterViewModel asUserSettingsElement.
	anElement ifNil: [ ^ self ].
	self addSettingsElement: anElement
]
