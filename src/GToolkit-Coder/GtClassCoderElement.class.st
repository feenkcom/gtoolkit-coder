Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'contentPane',
		'navigationElement',
		'panesNavigationButton',
		'treeNavigationButton',
		'classCoder',
		'spotterButton',
		'container',
		'contentTabs',
		'breadcrumb',
		'addClassButton'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtClassCoderElement >> buildAddClassButton [
	| dropdown |
	dropdown := BrDropdown new.
	^ dropdown
		look: BrGlamorousDropdownLook;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		toggle: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons add asElement;
				yourself ];
		popup: [ | coder |
			coder := GtClassDefinitionCoder new
				expanded: true;
				source:
					'Object subclass: #NameOfSubclass
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''''';
				yourself.
			coder announcer
				when: GtCoderEvaluationAnnouncement
				do: [ :e | 
					dropdown collapse.
					classCoder displayClass: e value ].
			coder asElement
				hFitContent;
				vFitContent;
				yourself ];
		yourself
]

{ #category : #'as yet unclassified' }
GtClassCoderElement >> buildBreadcrumb [
	^ BrBreadcrumb new
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look:
							(BrGlamorousLabelLook new thin
								foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin: (BlInsets left: 3 right: 3) ]);
		yourself
]

{ #category : #'as yet unclassified' }
GtClassCoderElement >> buildBreadcrumbToggleForClass: aClass [
	^ BrToggle new
		margin: (BlInsets all: 2);
		activated: (classCoder methodsCoder filteredClass: aClass);
		label: (aClass name asRopedText attributes: {(BlFontSizeAttribute size: 12)});
		look: GtClassBreadcrumbToggleLook;
		when: BrToggleActivatedEvent
			do: [ :anEvent | 
			classCoder methodsCoder addMethodsForClass: aClass.
			classCoder definitionsCoder addDefinitionsForClass: aClass.
			classCoder commentsCoder addCommentForClass: aClass ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | 
			classCoder methodsCoder removeMethodsForClass: aClass.
			classCoder definitionsCoder removeDefinitionsForClass: aClass.
			classCoder commentsCoder removeCommentForClass: aClass.
			classCoder methodsCoder hasFilter
				ifFalse: [ aClass == classCoder theClass
						ifTrue: [ anEvent consumed: true ].
					(breadcrumb itemAt: 1) activate ] ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContainer [
	| tab tabGroup |
	tab := BrTab new
		look: BrGlamorousTabLook new invisibleBar;
		label: '';
		stencil: [ contentPane := self buildContentPane ];
		actionsStencil: [ BrToolbar new
				look: BrGlamorousToolbarLook new;
				addItem: (spotterButton := self buildSpotterButton);
				addItem: (treeNavigationButton := self buildTreeNavigationToolbarButton);
				addItem: (addClassButton := self buildAddClassButton);
				yourself ];
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		addChild:
			((breadcrumb := self buildBreadcrumb) asScrollableElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself);
		yourself.
	tabGroup := BrTabGroup new
		look:
			(BrMaterialTabGroupLook new
				headerBackground: (Color fromHexString: 'd9f7be'));
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		yourself.
	^ tabGroup
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentPane [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		in: [ :e | 
			classCoder methodsCoder
				ifNotNil: [ e addChild: (contentTabs := self buildContentTabs) ] ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentTabs [
	^ BrTabGroup new
		look: BrGlamorousTabGroupLook new;
		constraintsDo: [ :c | c linear weight: 2 ];
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
				label: 'Definitions';
				stencil: [ classCoder definitionsCoder asElement ]);
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Comments';
				stencil: [ classCoder commentsCoder asElement ])
]

{ #category : #'building ui' }
GtClassCoderElement >> buildNavigationElement [
	^ classCoder navigationModel asElement
		constraintsDo: [ :c | c linear weight: 0.5 ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildPanesNavigationToolbarButton [
	^ BrToggle new
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons threepanes asElement;
		when: BrToggleActivatedEvent
			do: [ :anEvent | 
			treeNavigationButton deactivate.
			classCoder navigationModel: GtClassCoderPackagesPanesNavigation new ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | classCoder navigationModel: nil ];
		yourself
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
					model := GtSpotter new initializeWith: GtCoderSpotterStart new.
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
							model announcer subscriptions subscriptions
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
GtClassCoderElement >> buildTreeNavigationToolbarButton [
	^ BrToggle new
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons tree asElement;
		when: BrToggleActivatedEvent
			do:
				[ :anEvent | "panesNavigationButton deactivate." classCoder navigationModel: GtClassCoderPackagesTreeNavigation new ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | classCoder navigationModel: nil ];
		yourself
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
			do: [ :ann | 
			self
				updateContentTabs;
				updateBreadcrumb ];
		when: GtCoderNavigationModelChangedAnnouncement
			do: [ :ann | self updateNavigationElement ].
	container := self buildContainer.
	self
		removeChildren;
		addChild: container;
		updateNavigationElement;
		updateBreadcrumb
]

{ #category : #subscriptions }
GtClassCoderElement >> definitionChanged: anAnnouncement [
	anAnnouncement classAffected == classCoder theClass
		ifFalse: [ ^ self ].
	classCoder methodsCoder forClass: classCoder theClass.
	classCoder definitionsCoder forClass: classCoder theClass.
	classCoder commentsCoder forClass: classCoder theClass.
	self
		updateContentTabs;
		updateBreadcrumb
]

{ #category : #initialization }
GtClassCoderElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	SystemAnnouncer uniqueInstance weak
		when:
			ClassModificationApplied , ClassModifiedClassDefinition
				, ClassParentRenamed , ClassRenamed
		send: #definitionChanged:
		to: self
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeContentTabs [
	contentTabs
		ifNotNil: [ contentPane removeChild: contentTabs.
			contentTabs := nil ]
]

{ #category : #'updating ui' }
GtClassCoderElement >> removeNavigationElement [
	navigationElement
		ifNotNil: [ contentPane removeChild: navigationElement.
			navigationElement := nil ]
]

{ #category : #'as yet unclassified' }
GtClassCoderElement >> updateBreadcrumb [
	breadcrumb removeAllItems.
	classCoder theClass
		ifNotNil: [ :c | 
			c
				withAllSuperclassesDo:
					[ :each | breadcrumb addItem: (self buildBreadcrumbToggleForClass: each) ] ]
]

{ #category : #'updating ui' }
GtClassCoderElement >> updateContentTabs [
	| childIndex |
	contentTabs
		ifNil: [ childIndex := contentPane children size + 1 ]
		ifNotNil: [ childIndex := contentPane childIndexOf: contentTabs ].
	self removeContentTabs.
	contentTabs := self buildContentTabs.
	contentPane addChild: contentTabs asElement at: childIndex
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
