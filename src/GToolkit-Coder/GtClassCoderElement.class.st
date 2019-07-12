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
		'contentElement',
		'spotterButton'
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
				actionsStencil: [ BrToolbar new
						look: BrGlamorousToolbarLook new;
						addItem:
							(BrEditor new
								look: BrGlamorousCodeEditorLook new;
								geometry: (BlRectangle cornerRadius: 4);
								border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
								hExact: 100;
								vMatchParent;
								padding: (BlInsets all: 3);
								in: [ :e | 
									e editor
										when: BrTextEditorInsertedEvent
											do: [ classCoder methodsCoder implementorsFilterString: e text asString ];
										when: BrTextEditorDeletedEvent
											do: [ classCoder methodsCoder implementorsFilterString: e text asString ].
									classCoder methodsCoder implementorsFilterString
										ifNotNil: [ :g | e text: g asString asRopedText ] ];
								yourself);
						addItem:
							(BrButton new
								look: BrGlamorousButtonWithIconLook;
								icon: BrGlamorousIcons add asElement;
								action: [ classCoder methodsCoder addNewCoder ];
								yourself);
						yourself ]);
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
"	headerPane addChild: selectorElement."
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
GtClassCoderElement >> buildSpotterButton [
	 | dropdown |
	dropdown := BrDropdown new.
	^ dropdown
				look:
					(BrGlamorousDropdownLook new
						outskirtsEmbellisher: [ :e | 
							e
								background: BrGlamorousColors lightBorderColor;
								yourself ];
						yourself);
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ];
				toggle: [ BrButton new
						look: BrGlamorousButtonWithIconLook;
						icon: BrGlamorousIcons search asElement;
						when: BlElementBackgroundChangedEvent
							do: [ :e | 
							(dropdown isExpanded
								and: [ e target background paint color
										~= BrGlamorousColors lightBorderColor ])
								ifTrue: [ e target background: BrGlamorousColors lightBorderColor ] ];
						yourself ];
				popup: [ | model |
					model := GtSpotter new.
					model announcer
						when: GtSpotterActOn
						do: [ :e | 
							| item |
							item := e element.
							e actedUpon: true.
							[ (item isKindOf: GtSpotterCandidate)
								and: [ item item ~~ item ] ] whileTrue: [ item := item item ].
							((#(singleClick doubleClick keyPressed) includes: e eventType)
								and: [ item isKindOf: Behavior ])
								ifTrue: [ dropdown collapse.
									self classCoder displayClass: item ] ].
					GtSpotterElement new
						spotterModel: model;
						constraintsDo: [ :c | 
							c horizontal exact: 600.
							c vertical exact: 400 ];
						margin: (BlInsets all: 1);
						geometry: (BlRectangle cornerRadius: 4);
						in: [ :e | 
							self
								flag: 'FIXME need to remove original listener to avoid phlow inspect'.
							model announcer weak gtSubscriptions subscriptions
								detect: [ :g | 
									g announcementClass == GtSpotterSelectedCandidateChanged
										and: [ g action isMessageSend
												and: [ g action selector = #onCandidateSelected:
														and: [ g action receiver == e ] ] ] ]
								ifFound: [ :g | g announcer subscriptions remove: g ] ];
						yourself ];
				yourself 
]

{ #category : #'building ui' }
GtClassCoderElement >> buildToolbar [ 	
	| toolbar |
	toolbar := BrToolbar new.
	toolbar look: BrGlamorousToolbarLook new.
	spotterButton := self buildSpotterButton.
	treeNavigationButton := self buildTreeNavigationToolbarButton.
	toolbar margin: (BlInsets right: -2).
	toolbar addItem: treeNavigationButton.
	toolbar addItem: spotterButton.
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
			"panesNavigationButton deactivate."
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
