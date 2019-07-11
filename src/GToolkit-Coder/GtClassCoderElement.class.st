Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'contentPane',
		'headerPane',
		'navigationElement',
		'panesNavigationButton',
		'treeNavigationButton',
		'classCoder',
		'contentElement'
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
	classCoder theClass
		withAllSuperclassesDo: [ :each | 
			| toggle |
			toggle := BrToggle new
				margin: (BlInsets all: 2);
				activated: (classCoder methodsCoder filteredClass: each);
				label: (each name asRopedText attributes: {(BlFontSizeAttribute size: 12)});
				look: GtClassBreadcrumbToggleLook;
				when: BrToggleActivatedEvent
					do: [ :anEvent | 
					classCoder methodsCoder addMethodsForClass: each.
					classCoder definitionsCoder addDefinitionsForClass: each.
					classCoder commentsCoder addCommentForClass: each ];
				when: BrToggleDeactivatedEvent
					do: [ :anEvent | 
					classCoder methodsCoder removeMethodsForClass: each.
					classCoder methodsCoder hasFilter
						ifFalse: [ each == classCoder theClass
								ifTrue: [ anEvent consumed: true ].
							(breadcrumb itemAt: 1) activate ].
					classCoder definitionsCoder removeDefinitionsForClass: each.
					classCoder commentsCoder removeCommentForClass: each ].
			breadcrumb addItem: toggle ].
	^ breadcrumb asScrollableElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentElement [
	^ contentElement := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 2 ];
		addChildren:
			{self buildBreadcrumb.
			self buildContentTabs};
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentPane [
	self buildHeaderPane.
	contentPane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: contentPane.
	self updateNavigationElement.
	classCoder methodsCoder
		ifNotNil: [ contentPane addChild: self buildContentElement ]
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentTabs [
	^ BrTabGroup new
		look: BrGlamorousTabGroupLook new;
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Methods';
				stencil: [ classCoder methodsCoder asElement ];
				actionsStencil: [ | button |
					button := BrButton new.
					button
						look: BrGlamorousButtonWithIconLook;
						icon: BrGlamorousIcons add asElement;
						margin:
							(BlInsets
								top: 7
								left: 10
								bottom: 0
								right: 0);
						action: [ classCoder methodsCoder addNewCoder ].
					button ]);
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Definition';
				stencil: [ classCoder definitionsCoder asElement ]);
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Comment';
				stencil: [ classCoder commentsCoder asElement ])
]

{ #category : #'building ui' }
GtClassCoderElement >> buildHeaderPane [
	| selectorElement toolbarElement |
	headerPane := BlElement new
		layout: BlLinearLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	selectorElement := classCoder searchFilter asElement.
	toolbarElement := self buildToolbar.
	toolbarElement
		constraintsDo: [ :c | 
			c linear horizontal alignRight.
			c horizontal fitContent.
			c vertical matchParent ].
	headerPane addChild: selectorElement.
	headerPane addChild: toolbarElement.
	self addChild: headerPane
]

{ #category : #'building ui' }
GtClassCoderElement >> buildNavigationElement [
	| element |
	element := classCoder navigationModel asElement.
	"element padding: (BlInsets all: 10)."
	element constraintsDo: [ :c | c linear weight: 0.5 ].
	^ element
]

{ #category : #'building ui' }
GtClassCoderElement >> buildPanesNavigationToolbarButton [
	| toggle |
	toggle := BrToggle new
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons threepanes asElement;
		when: BrToggleActivatedEvent
			do: [ :anEvent | 
			treeNavigationButton deactivate.
			classCoder navigationModel: GtClassCoderPackagesPanesNavigation new ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | classCoder navigationModel: nil ].
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
		when: BrToggleActivatedEvent
			do: [ :anEvent | 
			panesNavigationButton deactivate.
			classCoder navigationModel: GtClassCoderPackagesTreeNavigation new ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | classCoder navigationModel: nil ].
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
		do: [ :ann | self updateContentElement ].
	classCoder
		when: GtCoderNavigationModelChangedAnnouncement
		do: [ :ann | self updateNavigationElement ].
	self buildContentPane.
]

{ #category : #subscriptions }
GtClassCoderElement >> definitionChanged: anAnnouncement [
	anAnnouncement classAffected == classCoder theClass
		ifFalse: [ ^ self ].
	classCoder methodsCoder forClass: classCoder theClass.
	classCoder definitionsCoder forClass: classCoder theClass.
	classCoder commentsCoder forClass: classCoder theClass.
	self updateContentElement
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
	SystemAnnouncer uniqueInstance weak
		when:
			ClassModificationApplied , ClassModifiedClassDefinition
				, ClassParentRenamed , ClassRenamed
		send: #definitionChanged:
		to: self
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeContentElement [
	contentElement
		ifNotNil: [ contentPane removeChild: contentElement.
			contentElement := nil ]
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeNavigationElement [
	navigationElement ifNotNil: [
		contentPane removeChild: navigationElement.
		navigationElement := nil ].
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateContentElement [
	| childIndex |
	contentElement
		ifNil: [ childIndex := 1 ]
		ifNotNil: [ childIndex := contentPane childIndexOf: contentElement ].
	self removeContentElement.
	self buildContentElement.
	contentPane addChild: contentElement asElement at: childIndex
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateNavigationElement [
	| navigationModel |
	self removeNavigationElement.
	navigationModel := classCoder navigationModel.
	navigationModel ifNil: [ ^ self ].
	navigationModel displayPosition = #top
		ifTrue: [ contentPane layout: BlLinearLayout vertical ].
	navigationModel displayPosition = #left
		ifTrue: [ contentPane layout: BlLinearLayout horizontal ].
	navigationElement := self buildNavigationElement.
	contentPane addChildFirst: navigationElement
]
