Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'contentPane',
		'headerPane',
		'navigationElement',
		'panesNavigationButton',
		'treeNavigationButton',
		'classCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'as yet unclassified' }
GtClassCoderElement >> buildBreadcrumb [
	| breadcrumb |
	breadcrumb := BrBreadcrumb new.
	breadcrumb
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look:
							(BrGlamorousLabelLook new thin
								foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin:
							(BlInsets
								top: 6
								left: 3
								bottom: 0
								right: 3) ]).
	self classCoder theClass
		withAllSuperclassesDo: [ :each | 
			| toggle |
			toggle := BrToggle new
				margin: (BlInsets all: 2);
				activated: (self classCoder methodsCoder filteredClass: each);
				label: (each name asRopedText attributes: {(BlFontSizeAttribute size: 12)});
				look: GtClassBreadcrumbToggleLook;
				when: BrToggleActivatedEvent
					do: [ :anEvent | self classCoder methodsCoder addMethodsForClass: each ];
				when: BrToggleDeactivatedEvent
					do: [ :anEvent | 
					self classCoder methodsCoder removeMethodsForClass: each.
					self classCoder methodsCoder hasFilter
						ifFalse: [ each == self classCoder theClass
								ifTrue: [ anEvent consumed: true ].
							(breadcrumb itemAt: 1) activate ] ].
			breadcrumb addItem: toggle ].
	^ breadcrumb asScrollableElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContent [
	self buildHeaderPane.
	contentPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: contentPane.
	self updateNavigationElement.
	self classCoder methodsCoder
		ifNotNil: [ contentPane
				addChild:
					(BlElement new
						layout: BlLinearLayout vertical;
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical matchParent.
							c linear weight: 2 ];
						addChildren:
							{self buildBreadcrumb.
							self buildContentTabs};
						yourself) ]
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentTabs [
	^ BrTabGroup new
		look: BrGlamorousTabGroupLook new;
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Methods';
				stencil: [ self classCoder methodsCoder asElement ]);
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Definition';
				stencil: [ self classCoder definitionsCoder asElement ]);
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Comment';
				stencil: [ self classCoder commentsCoder asElement ])
]

{ #category : #'building ui' }
GtClassCoderElement >> buildHeaderPane [
	| selectorElement toolbarElement |
	headerPane := BlElement new
		layout: BlLinearLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	selectorElement := self classCoder searchFilter asElement.
	toolbarElement := self buildToolbar.
	toolbarElement 
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c horizontal fitContent.
			c vertical matchParent ].
	headerPane addChild: selectorElement.
	headerPane addChild: toolbarElement.	
	self addChild: headerPane.
]

{ #category : #'building ui' }
GtClassCoderElement >> buildNavigationElement [
	| element |
	element := self classCoder navigationModel asElement.
	"element padding: (BlInsets all: 10)."
	element constraintsDo: [ :c |
		c linear weight: 0.5 ].
	^ element
]

{ #category : #'building ui' }
GtClassCoderElement >> buildPanesNavigationToolbarButton [	
	| toggle |
	toggle := BrToggle new 
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons threepanes asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			treeNavigationButton deactivate.
			self classCoder 
				navigationModel: GtClassCoderPackagesPanesNavigation new ];
		when: BrToggleDeactivatedEvent do: [ :anEvent | 
			self classCoder navigationModel: nil ].
	^ toggle
]

{ #category : #'building ui' }
GtClassCoderElement >> buildToolbar [ 	
	| toolbar |
	toolbar := BrToolbar new.
	toolbar look: BrGlamorousToolbarLook new.
	panesNavigationButton := self buildPanesNavigationToolbarButton.
	treeNavigationButton := self buildTreeNavigationToolbarButton.
	toolbar margin: (BlInsets right: -2).
	toolbar addItem: treeNavigationButton.
	toolbar addItem: panesNavigationButton.
	^ toolbar
]

{ #category : #'building ui' }
GtClassCoderElement >> buildTreeNavigationToolbarButton [	
	| toggle |
	toggle := BrToggle new 
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons tree asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			panesNavigationButton deactivate.
			self classCoder 
				navigationModel: GtClassCoderPackagesTreeNavigation new ];
		when: BrToggleDeactivatedEvent do: [ :anEvent |
			self classCoder navigationModel: nil ].
	^ toggle
]

{ #category : #accessing }
GtClassCoderElement >> classCoder [
	^ classCoder
]

{ #category : #accessing }
GtClassCoderElement >> classCoder: aCoder [
	classCoder := aCoder.
	classCoder
		when: GtCoderClassSelectedAnnouncement
		do: [ :ann | self updateMethodsCoderElement ].
	classCoder
		when: GtCoderNavigationModelChangedAnnouncement
		do: [ :ann | self updateNavigationElement ].
	self buildContent.
]

{ #category : #accessing }
GtClassCoderElement >> contentPane [
	^ contentPane
]

{ #category : #initialization }
GtClassCoderElement >> initialize [ 
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self padding: (BlInsets left: 10 right: 10).
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeNavigationElement [
	navigationElement ifNotNil: [
		contentPane removeChild: navigationElement.
		navigationElement := nil ].
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateMethodsCoderElement [
	| methodsCoder |
	methodsCoder := self classCoder methodsCoder.
	self contentPane hasChildren ifTrue: [
		self contentPane removeChildAt: self contentPane childrenCount ].
	self contentPane addChild: methodsCoder asElement
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateNavigationElement [
	| navigationModel |
	
	self removeNavigationElement.
	navigationModel := self classCoder navigationModel.
	navigationModel ifNil: [ ^ self ].
	
	navigationModel displayPosition = #top
		ifTrue: [ contentPane layout: BlLinearLayout vertical ].
	navigationModel displayPosition = #left
		ifTrue: [ contentPane layout: BlLinearLayout horizontal ].
	
	navigationElement := self buildNavigationElement.
	contentPane addChildFirst: navigationElement.
]
