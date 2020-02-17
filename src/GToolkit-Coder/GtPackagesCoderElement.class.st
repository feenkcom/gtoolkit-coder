Class {
	#name : #GtPackagesCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packagesCoder',
		'contentPane',
		'selectedCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtPackagesCoderElement >> buildAddClassButton [
	| look |
	^ BrButton new
		label: 'Add class';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons add asElement;
								yourself ]
						content: [ | coder |
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
									look hide.
									self updateSelection: (packagesCoder coderForClass: e value) ].
							coder asElement
								hFitContent;
								vFitContent;
								margin: (BlInsets all: 10);
								yourself ]);
		icon: BrGlamorousIcons add asElement;
		yourself
]

{ #category : #'as yet unclassified' }
GtPackagesCoderElement >> buildClassHierarchyTree [
	| classes tree |
	classes := (selectedCoder theClass withAllSuperclasses
		, selectedCoder theClass allSubclasses) asIdentitySet.
	tree := BrColumnedTree new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		items: {(packagesCoder coderForClass: ProtoObject)}
			children: [ :anObject | 
			((anObject theClass subclasses select: [ :c | classes includes: c ])
				sorted: [ :a :b | a name < b name ])
				collect: [ :c | packagesCoder coderForClass: c ] ];
		yourself.
	tree column
		title: 'Name';
		stencil: [ :aNode | 
			BlElement new
				layout: BlLinearLayout horizontal;
				addChild: aNode value icon;
				addChild:
					(BlTextElement new
						margin: (BlInsets all: 3);
						text: aNode value name asRopedText glamorousRegularFontAndSize;
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical fitContent ]);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself ].
	^ tree
		selectAndScrollTo: selectedCoder;
		yourself
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildContentPane [
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout horizontal.
	contentPane padding: (BlInsets all: 5).
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ contentPane
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildHierarchyButton [
	^ BrButton new
		label: 'Show Package and Class Hierarchies';
		look:
			BrGlamorousButtonWithIconLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons tree asElement;
								yourself ]
						content: [ self buildHierarchyTabs ]);
		icon: BrGlamorousIcons tree asElement;
		yourself
]

{ #category : #'as yet unclassified' }
GtPackagesCoderElement >> buildHierarchyTabs [
	| packageTab classTab packageTree classTree tabGroup |
	packageTab := BrTab new
		look: BrGlamorousTabLook new;
		label: 'Package Hierarchy';
		stencil: [ packageTree := self buildPackageHierarchyTree
				when: BrSelectionChanged
					do: [ :anEvent | 
					anEvent target
						selectedNodeDo: [ :aNode | 
							self updateSelection: aNode value.
							self isSelectedCoderClassCoder
								ifTrue: [ (tabGroup hasTab: classTab)
										ifFalse: [ tabGroup addTab: classTab ].
									classTree
										ifNotNil: [ classTree selectAndScrollTo: selectedCoder ] ] ] ];
				yourself ];
		yourself.
	classTab := BrTab new
		look: BrGlamorousTabLook new;
		label: 'Class Hierarchy';
		stencil: [ classTree := self buildClassHierarchyTree
				when: BrSelectionChanged
					do: [ :anEvent | 
					anEvent target
						selectedNodeDo: [ :aNode | 
							self updateSelection: aNode value.
							packageTree
								ifNotNil: [ packageTree selectAndScrollTo: selectedCoder ] ] ];
				yourself ];
		yourself.
	tabGroup := BrTabGroup new
		look: BrGlamorousTabGroupLook new;
		addTab: packageTab;
		vExact: 400;
		hExact: 400;
		yourself.
	self isSelectedCoderClassCoder
		ifTrue: [ tabGroup addTab: classTab ].
	^ tabGroup
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildPackageHierarchyTree [
	| tree |
	tree := BrColumnedTree new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		items: {packagesCoder}
			children: [ :anObject | 
			anObject packageTreeCoders
				asSortedCollection: [ :a :b | a name < b name ] ];
		yourself.
	tree column
		title: 'Name';
		stencil: [ :aNode | 
			BlElement new
				layout: BlLinearLayout horizontal;
				addChild: aNode value icon;
				addChild:
					(BlTextElement new
						margin: (BlInsets all: 3);
						text: aNode value name asRopedText glamorousRegularFontAndSize;
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical fitContent ]);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself ].
	^ tree
		selectAndScrollTo: selectedCoder;
		yourself
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildPackageList [
	| element |
	element := BrSimpleList new.
	element stencil: [:each | each asCardElement
					 constraintsDo: [:c | c horizontal matchParent.
							c vertical fitContent ];
					 yourself ].
	element display: (packagesCoder coders asSortedCollection: [:a :b | a name < b name ]).
	^element
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildPackagesElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element padding: (BlInsets all: 5).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
				text: packagesCoder name).
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: BrGlamorousLabelLook new glamorousRegularFont;
				text: packagesCoder coders size printString , ' Packages').
	element addChild: self buildPackageList.
	^ element
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildSpotterButton [
	| look |
	^ BrButton new
		label: 'Search';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						stencil: [ | model |
							model := GtSpotter new initializeWith: GtCoderSpotterStart new.
							model announcer
								when: GtSpotterActOn
								do: [ :e | 
									| item |
									item := e element.
									e actedUpon: true.
									self flag: 'FIXME candidates may be wrapped for some reason'.
									[ (item isKindOf: GtSpotterCandidate)
										and: [ item item ~~ item ] ]
										whileTrue: [ item := item item ].
									((#(singleClick doubleClick keyPressed) includes: e eventType)
										and: [ {RPackage.
											ClassDescription.
											CompiledMethod} anySatisfy: [ :f | item isKindOf: f ] ])
										ifTrue: [ look hide.
											(item isKindOf: RPackage)
												ifTrue: [ self updateSelection: (packagesCoder coderForPackage: item) ].
											(item isKindOf: ClassDescription)
												ifTrue: [ self updateSelection: (packagesCoder coderForClass: item) ].
											(item isKindOf: CompiledMethod)
												ifTrue: [ | classCoder |
													classCoder := packagesCoder
														coderForClass: item methodClass.
													self updateSelection: classCoder.
													classCoder withSelectedMethod: item ] ] ].
							BlElement new
								look:
									(BrGlamorousDropdownLook new
										handle:
											(BrButton new
												look:
													BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
														- BrGlamorousButtonExteriorLook;
												icon: BrGlamorousIcons search asElement;
												yourself);
										content:
											(GtSpotterElement new
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
												yourself);
										yourself);
								background: BrGlamorousColors secondaryHeaderBackgroundColor;
								yourself ]);
		icon: BrGlamorousIcons search asElement;
		yourself
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildToolbar [
	^ BrToolbar new
		look: BrGlamorousToolbarLook new;
		padding:
			(BlInsets
				top: 10
				left: 0
				bottom: 0
				right: 5);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ];
		addItem: self buildSpotterButton;
		addItem: self buildHierarchyButton;
		addItem: self buildAddClassButton;
		yourself
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> coders: aPackagesCoder [
  packagesCoder := aPackagesCoder.
  self updateSelection: packagesCoder.
  packagesCoder when: GtPackagesCoderNavigationAnnouncement do: [:evt |  self updateSelection: evt coder ]
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> initialize [
	super initialize.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self buildContentPane.
	self addChild: self buildToolbar
]

{ #category : #testing }
GtPackagesCoderElement >> isSelectedCoderClassCoder [
	^ selectedCoder isKindOf: GtClassCoder
]

{ #category : #events }
GtPackagesCoderElement >> updateSelection: aCoder [
	| coderElement |
	selectedCoder := aCoder.
	coderElement := selectedCoder = packagesCoder
		ifTrue: [ self buildPackagesElement ]
		ifFalse: [ selectedCoder asElement ].
	contentPane
		removeChildNamed: #coder;
		addChild: coderElement as: #coder
]
