Class {
	#name : #GtClassCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder',
		'container',
		'contentPane',
		'contentTabs',
		'breadcrumb',
		'navigationElement'
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
				margin: (BlInsets all: 10);
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
					(breadcrumb itemAt: 1) widgetDo: #activate ] ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContainer [
	| tab tabGroup |
	tab := BrTab new
		look: BrGlamorousTabWithoutBarLook;
		label: '';
		stencil: [ contentPane := self buildContentPane ];
		toolbarStencil: [ BrToolbar new
				look: BrGlamorousToolbarLook new;
				addItem: self buildSpotterButton;
				addItem: self buildPackagesTreeButton;
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
				headerBackground: BrGlamorousColors defaultButtonBorderColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: (Color fromHexString: 'a0d911')"BrGlamorousColors successBorderColor";
				yourself);
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
			classCoder theClass
				ifNil: [ contentTabs := nil ]
				ifNotNil: [ e addChild: (contentTabs := self buildContentTabs) ] ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildContentTabs [
	| tabPragmas tabGroup |
	tabPragmas := self classViewPragmas.
	tabGroup := BrTabGroup new.
	tabGroup look: BrGlamorousTabGroupLook new.
	tabGroup constraintsDo: [ :c | c linear weight: 2 ].
	tabPragmas
		do: [ :each | 
			classCoder theClass
				perform: each method selector
				with: tabGroup
				with: classCoder ].
	^ tabGroup
]

{ #category : #'building ui' }
GtClassCoderElement >> buildNavigationElement [
	^ classCoder navigationModel asElement
		constraintsDo: [ :c | c linear weight: 0.7 ];
		yourself
]

{ #category : #'building ui' }
GtClassCoderElement >> buildPackagesTreeButton [
	^ BrToggle new
		look: BrGlamorousButtonWithIconLook + BrGlamorousToggleBackgroundLook;
		icon: BrGlamorousIcons tree asElement;
		when: BrToggleActivatedEvent do: [ self updateNavigationElement ];
		when: BrToggleDeactivatedEvent
			do: [ navigationElement removeFromParent ];
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
					self flag: 'FIXME candidates may be wrapped for some reason'.
					[ (item isKindOf: GtSpotterCandidate) and: [ item item ~~ item ] ]
						whileTrue: [ item := item item ].
					((#(singleClick doubleClick keyPressed) includes: e eventType)
						and: [ {RPackage.
							ClassDescription.
							CompiledMethod} anySatisfy: [ :f | item isKindOf: f ] ])
						ifTrue: [ dropdown collapse.
							(item isKindOf: RPackage)
								ifTrue: [ self classCoder navigationModel
										ifNotNil: [ :f | f packagesFilterString: item name ] ].
							(item isKindOf: ClassDescription)
								ifTrue: [ self classCoder navigationModel
										ifNotNil: [ :f | f packagesFilterString: item package name ].
									self classCoder forClass: item ].
							(item isKindOf: CompiledMethod)
								ifTrue: [ self classCoder navigationModel
										ifNotNil: [ :f | f packagesFilterString: item methodClass package name ].
									self classCoder forClass: item methodClass.
									self classCoder methodsCoder
										implementorsFilterString: item selector ] ] ].
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
				updateNavigationElement;
				updateContentTabs;
				updateBreadcrumb ];
		when: GtCoderNavigationModelChangedAnnouncement
			do: [ :ann | self updateNavigationElement ].
	container ifNotNil: #removeFromParent.
	container := self buildContainer.
	self
		addChildFirst: container;
		updateBreadcrumb
]

{ #category : #private }
GtClassCoderElement >> classViewPragmas [
	| pragmas |
	pragmas := Pragma
		allNamed: #gtClassView:
		from: classCoder theClass class
		to: Behavior.
	^ pragmas
		asSortedCollection: [ :a :b | a arguments first < b arguments first ]
]

{ #category : #subscriptions }
GtClassCoderElement >> definitionChanged: anAnnouncement [
	anAnnouncement classAffected == classCoder theClass
		ifFalse: [ ^ self ].
	self
		updateNavigationElement;
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

{ #category : #'updating ui' }
GtClassCoderElement >> updateNavigationElement [
	| navigationModel |
	navigationElement ifNotNil: #removeFromParent.
	navigationModel := classCoder navigationModel.
	navigationModel displayPosition = #top
		ifTrue: [ contentPane layout: BlLinearLayout vertical ].
	navigationModel displayPosition = #left
		ifTrue: [ contentPane layout: BlLinearLayout horizontal ].
	navigationElement := self buildNavigationElement.
	contentPane addChildFirst: navigationElement
]
