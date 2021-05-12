Class {
	#name : #GtCoderExpanderWithoutShadowAptitude,
	#superclass : #BrExpanderAptitude,
	#instVars : [
		'sidebar',
		'toggle',
		'container',
		'borderWidth',
		'expandedBorderWidth',
		'borderPaint',
		'borderFocusedPaint',
		'cornerRadius',
		'styleLook',
		'padding'
	],
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> borderFocusedPaint [
	^ borderFocusedPaint
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> borderFocusedPaint: aPaintOrColor [
	borderFocusedPaint := aPaintOrColor
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> borderPaint [
	^ borderPaint
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> borderPaint: aPaintOrColor [
	borderPaint := aPaintOrColor
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> borderWidth [
	^ borderWidth
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> borderWidth: anInteger [
	borderWidth := anInteger
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> cornerRadius [
	^ cornerRadius
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> cornerRadius: aNumber [
	cornerRadius := aNumber
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowAptitude >> defaultBorderPaint [
	^ self theme default lightBorderColor
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowAptitude >> defaultFocusedBorderPaint [
	^ (self theme default primaryBorderColor alpha: 0.4)
		gtOpaqueColorOnWhite
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> expandedBorderWidth [
	<return: #Number>

	^ expandedBorderWidth
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> expandedBorderWidth: aNumber [
	expandedBorderWidth := aNumber
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowAptitude >> initialize [
	| aTriangle |
	super initialize.

	borderWidth := 0.
	expandedBorderWidth := 0.
	cornerRadius := 3.
	padding := BlInsets all: 4.

	borderPaint := self defaultBorderPaint.
	borderFocusedPaint := self defaultFocusedBorderPaint.

	aTriangle := self newTriangle.
	toggle := self newToggle.
	toggle addChild: aTriangle.

	sidebar := self newSidebar.
	sidebar addChild: toggle.

	container := BlElement new
		padding: self padding;
		layout: BlLinearLayout vertical.

	self add: (BrStyleCommonAptitude new
		collapsed: [ :aStyle |
			aStyle border: (BlBorder paint: self borderPaint width: self borderWidth) ];
		expanded: [ :aStyle |
			aStyle background: Color white.
			aStyle border: (BlBorder paint: self borderPaint width: self expandedBorderWidth) ];
		focused: [ :aStyle | (BlBorder paint: self borderFocusedPaint width: self expandedBorderWidth) ]).

	self add: (BrStyleCommonAptitude new
		@ aTriangle;
		collapsed: [ :aStyle | aStyle geometry: self newCollapsedTriangleGeometry ];
		expanded: [ :aStyle | aStyle geometry: self newExpandedTriangleGeometry ]).

	self add: (BrStyleCommonAptitude new
		@ sidebar;
		default: [ :aStyle | aStyle background: self borderPaint ];
		focused: [ :aStyle | aStyle background: self borderFocusedPaint ]).

	self addChangeAddChildAs: #(sidebar) with: [ sidebar ].
	self addChangeAddChildAs: #(content) with: [ container ].
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal ].
	self
		addChangeProperty: #(widget geometry)
		with: [ BlRoundedRectangleGeometry cornerRadius: self cornerRadius ]
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowAptitude >> newCollapsedTriangleGeometry [
	^ BlPolygon vertices: {
		(0 @ 0).
		(8 @ 4).
		(0 @ 8)
	}
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowAptitude >> newExpandedTriangleGeometry [
	^ BlPolygon vertices: {
		(0 @ 0).
		(8 @ 0).
		(4 @ 8)
	}
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowAptitude >> newSidebar [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		background: Color veryVeryLightGray
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowAptitude >> newToggle [
	^ BlElement new
		id: GtSourceCoderExpanderToggleId;
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: 4);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		background: Color transparent;
		when: BlClickEvent
			do: [ :anEvent |
				anEvent consumed: true.
				self dispatchEvent: BrExpansionToggleWish new ]
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowAptitude >> newTriangle [
	^ BlElement new
		size: 8 @ 8;
		background: (Color white alpha: 0.9);
		constraintsDo: [ :c | c linear vertical alignTop ]
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> padding [
	^ padding
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> padding: aBlInsets [
	padding := aBlInsets.
	container padding: aBlInsets
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowAptitude >> resizableElementsDo: aBlock [
	super resizableElementsDo: aBlock.
	aBlock value: container
]
