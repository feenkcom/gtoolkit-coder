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
	settingsContainer addChild: anElement as: #settings
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
	self when: BlClickEvent do: [ :anEvent | self onClickEvent: anEvent ]
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
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination backspace;
				action: [ self requestRemoveFilter ])
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

{ #category : #'api - filter view model' }
GtFilterNameElement >> onFilterViewModelChanged [
	self updateSettingsContainer
]

{ #category : #'private - updating' }
GtFilterNameElement >> removeSettingsElement [
	settingsContainer removeChildren
]

{ #category : #'event handling' }
GtFilterNameElement >> requestRemoveFilter [
]

{ #category : #'private - updating' }
GtFilterNameElement >> updateSettingsContainer [
	| anElement |
	self removeSettingsElement.
	anElement := self filterViewModel asUserSettingsElement.
	anElement ifNil: [ ^ self ].
	self addSettingsElement: anElement
]