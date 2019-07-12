Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder',
		'container',
		'contentPane',
		'contentTabs',
		'breadcrumb',
		'packagesFilter'
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
					classCoder forClass: e value ].
			coder asElement
				hFitContent;
				vFitContent;
				yourself ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildAddPackageButton [
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
		popup: [ | editor button |
			editor := BrEditor new
				look: BrGlamorousRegularEditorLook new;
				geometry: (BlRectangle cornerRadius: 4);
				border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
				hExact: 100;
				vMatchParent;
				padding: (BlInsets all: 3);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself.
			button := BrButton new
				look: BrGlamorousButtonWithIconLook;
				margin: (BlInsets left: 10);
				icon: BrGlamorousIcons accept asElement;
				action: [ RPackageOrganizer default createPackageNamed: editor text asString ];
				yourself.
			BlElement new
				layout: BlLinearLayout horizontal;
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ];
				addChild: editor;
				addChild: button;
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
		label: aClass name asRopedText glamorousRegularFontAndSize;
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
GtClassCoderElement >> buildCommentsTab [
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Comments';
		stencil: [ classCoder commentsCoder asElement ]
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
				addItem: self buildSpotterButton;
				addItem: self buildAddClassButton;
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
		addChild: (contentTabs := self buildContentTabs);
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentTabs [
	^ BrTabGroup new
		look: BrGlamorousTabGroupLook new;
		constraintsDo: [ :c | c linear weight: 2 ];
		addTab: self buildMethodsTab;
		addTab: self buildDefinitionsTab;
		addTab: self buildCommentsTab;
		addTab: self buildPackagesTab;
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildDefinitionsTab [
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Definitions';
		stencil: [ classCoder definitionsCoder asElement ]
]

{ #category : #'building ui' }
GtClassCoderElement >> buildMethodsTab [
	^ BrTab new
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
							classCoder methodsCoder implementorsFilterString
								ifNotNil: [ :g | e text: g asString asRopedText ].
							e editor
								when: BrTextEditorInsertedEvent
									do: [ classCoder methodsCoder implementorsFilterString: e text asString ];
								when: BrTextEditorDeletedEvent
									do: [ classCoder methodsCoder implementorsFilterString: e text asString ] ];
						yourself);
				addItem:
					(BrButton new
						look: BrGlamorousButtonWithIconLook;
						icon: BrGlamorousIcons add asElement;
						action: [ classCoder methodsCoder addNewCoder ];
						yourself);
				yourself ]
]

{ #category : #'as yet unclassified' }
GtClassCoderElement >> buildPackageTree: somePackages [
	| tree |
	tree := BrSimpleTree new.
	^ tree
		items: (somePackages sort: [ :a :b | a name < b name ])
			children: [ :anObject | 
			(anObject isKindOf: RPackage)
				ifTrue: [ (anObject classTags asOrderedCollection
						sort: [ :a :b | a name < b name ])
						, {(RPackageTag package: anObject name: '*Extensions')} ]
				ifFalse: [ (anObject isKindOf: RPackageTag)
						ifTrue: [ anObject name = '*Extensions'
								ifTrue: [ (anObject package extensionMethods
										collect: [ :e | e methodClass instanceSide ]) asSet
										asOrderedCollection sort: [ :a :b | a name < b name ] ]
								ifFalse: [ anObject classes asOrderedCollection
										sort: [ :a :b | a name < b name ] ] ]
						ifFalse: [ #() ] ] ];
		stencil:
			(BrSimpleTreeRowStencilBuilder new
				text:
					[ :anObject | anObject value name asRopedText glamorousRegularFontAndSize ]);
		when: BrSelectionChanged
			do: [ :anEvent | 
			anEvent
				selectedDo: [ :anInterval | 
					tree
						selectedNodeDo: [ :aNode | 
							aNode value isClass
								ifTrue: [ classCoder forClass: aNode value ] ] ] ];
		yourself
]

{ #category : #'as yet unclassified' }
GtClassCoderElement >> buildPackagesTab [
	| tab tree |
	tab := BrTab new.
	^ tab
		look: BrGlamorousTabLook new;
		label: 'Packages';
		stencil: [ tree := self buildPackageTree: RPackageOrganizer default packages ];
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
									do: [ (tree ifNotNil: #parent)
										ifNotNil: [ :f | 
											tree removeFromParent.
											tree := self
												buildPackageTree:
													(RPackageOrganizer default packages
														select:
															[ :g | g name asLowercase includesSubstring: e text asString asLowercase ]).
											f addChild: tree ] ];
								when: BrTextEditorDeletedEvent
									do: [ (tree ifNotNil: #parent)
										ifNotNil: [ :f | 
											tree removeFromParent.
											tree := self
												buildPackageTree:
													(RPackageOrganizer default packages
														select:
															[ :g | g name asLowercase includesSubstring: e text asString asLowercase ]).
											f addChild: tree ] ].
							packagesFilter ifNotNil: [ e text: packagesFilter ] ];
						yourself);
				addItem: self buildAddPackageButton ]
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
					self flag: 'FIXME candidates may be wrapped for some reason'.
					[ (item isKindOf: GtSpotterCandidate) and: [ item item ~~ item ] ]
						whileTrue: [ item := item item ].
					((#(singleClick doubleClick keyPressed) includes: e eventType)
						and: [ {RPackage.
							ClassDescription.
							CompiledMethod} anySatisfy: [ :f | item isKindOf: f ] ])
						ifTrue: [ dropdown collapse.
							(item isKindOf: RPackage)
								ifTrue: [ packagesFilter := item name.
									self classCoder methodsCoder implementorsFilterString: ''.
									self flag: 'FIXME how to reset a class'.
									"self classCoder forClass: nil."
									(contentTabs viewModel tabs at: 4) select ].
							(item isKindOf: ClassDescription)
								ifTrue: [ packagesFilter := item package name.
									self classCoder methodsCoder implementorsFilterString: ''.
									self classCoder forClass: item.
									(contentTabs viewModel tabs at: 1) select ].
							(item isKindOf: CompiledMethod)
								ifTrue: [ packagesFilter := item methodClass package name.
									self classCoder forClass: item methodClass.
									self classCoder methodsCoder
										implementorsFilterString: item selector.
									(contentTabs viewModel tabs at: 1) select ] ] ].
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
				updateBreadcrumb ].
	container := self buildContainer.
	self
		removeChildren;
		addChild: container;
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
