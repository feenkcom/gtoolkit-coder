"
I am the entrance point into the coder as a tool
"
Class {
	#name : #GtCoder,
	#superclass : #BlElement,
	#traits : 'TGtPagerPageInstantiator',
	#classTraits : 'TGtPagerPageInstantiator classTrait',
	#instVars : [
		'coderContent',
		'navigationModel'
	],
	#category : #'GToolkit-Coder-! Core'
}

{ #category : #'instance creation' }
GtCoder class >> forClass: aCompiledMethod [
	^ self forCoder: (GtClassCoder forClass: aCompiledMethod)
]

{ #category : #'instance creation' }
GtCoder class >> forCoder: aCoder [
	^ self basicNew initialize pushCoder: aCoder
]

{ #category : #'instance creation' }
GtCoder class >> forMethod: aCompiledMethod [
    | classCoder coder |
    classCoder := GtClassCoder forClass: aCompiledMethod methodClass.
    coder := self forCoder: classCoder.
    classCoder withSelectedMethod: aCompiledMethod.
    ^ coder
]

{ #category : #'instance creation' }
GtCoder class >> forPackage: anRPackage [
	^ self forCoder: (GtPackageCoder forPackage: anRPackage)
]

{ #category : #'instance creation' }
GtCoder class >> new [
	^ self forCoder: GtPackagesCoder new
]

{ #category : #'private - ui' }
GtCoder >> buildAddClassButton [
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
								icon: BrGlamorousVectorIcons add;
								yourself ]
						content: [ | element |
							element := GtCreateBehaviorElement new.
							element
								classBlock: [ :cls | 
									look hide.
									navigationModel selectClass: cls ].
							navigationModel
								selectedPackageDo: [ :package | element forPackage: package ].
							navigationModel
								selectedTagDo: [ :tag | element forPackageTag: tag ].
							navigationModel 
								selectedClassDo: [ :cls | element forSuperclass: cls ].
							element ]);
		icon: BrGlamorousVectorIcons add;
		yourself
]

{ #category : #'private - ui' }
GtCoder >> buildClassLabel [
	| aClassNameEditor aContainer |
	aContainer := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	aClassNameEditor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 18);
		inputFilter: BrTextEditorAlphaNumericInputFilter new;
		text: 'NameOfSubclass';
		margin: (BlInsets all: 0).
	(GtCompletionController
		on: aClassNameEditor
		strategy: GtClassesCompletionStrategy new) install.
	aContainer addChild: aClassNameEditor.
	^ aContainer
]

{ #category : #'private - ui' }
GtCoder >> buildHierarchyButton [
	^ BrButton new
		label: 'Show Package and Class Hierarchies';
		look: BrGlamorousButtonWithIconLook + (BrGlamorousWithDropdownLook
			handle: [
				BrButton new
					look: BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook - BrGlamorousButtonExteriorLook;
					icon: BrGlamorousIcons tree;
					yourself ]
			content: [
				(GtCoderNavigationPackagesTagsClassesElement new navigationModel: navigationModel)
					size: 400@400
			]);
		icon: BrGlamorousIcons tree asElement;
		yourself
]

{ #category : #'private - ui' }
GtCoder >> buildSpotterButton [
	| look |
	^ BrButton new
		label: 'Search';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						stencil: [ | model |
							model := GtSpotter new initializeWith: (GtCoderSpotterStart new navigationModel: navigationModel).
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
												ifTrue: [ navigationModel selectPackage: item ].
											(item isKindOf: ClassDescription)
												ifTrue: [ navigationModel selectClass: item ].
											(item isKindOf: CompiledMethod)
												ifTrue: [ navigationModel selectMethod: item ] ] ].
							BlElement new
								look:
									(BrGlamorousDropdownLook new
										handle:
											(BrButton new
												look:
													BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
														- BrGlamorousButtonExteriorLook;
												icon: BrGlamorousVectorIcons search;
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
		icon: BrGlamorousVectorIcons search;
		yourself
]

{ #category : #'private - ui' }
GtCoder >> buildToolbar [
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

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	
	self
		when: GtCoderToReplace
		do: [ :anEvent | self replaceFrom: anEvent ].

	self
		when: GtCoderToSpawn
		do: [ :anEvent | self spawnFrom: anEvent ].

	self
		when: GtCoderToSpawnInSpace
		do: [ :anEvent | self spawnInSpaceFrom: anEvent ].

	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	navigationModel := GtCoderNavigationPackagesTagsClassesModel fromPackages: RPackageOrganizer default packages.
	navigationModel when: GtCoderNavigationAnnouncement send: #updateCoder: to: self.

	coderContent := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	self addChild: coderContent.
	self addChild: self buildToolbar
]

{ #category : #'api - coder' }
GtCoder >> pushCoder: aCoderOrCoders [
	navigationModel selectCoder: aCoderOrCoders
]

{ #category : #'api - spawning' }
GtCoder >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	self pushCoder: aGtCoderToReplaceEvent coder
]

{ #category : #'api - spawning' }
GtCoder >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	self phlow spawnTool: (GtReadyCoderTool coder: (self class forCoder: aGtCoderToSpawnEvent coder))
]

{ #category : #'api - spawning' }
GtCoder >> spawnInSpaceFrom: aGtCoderToSpawnInSpaceEvent [
	aGtCoderToSpawnInSpaceEvent consumed: true.
	
	
]

{ #category : #'api - spawning' }
GtCoder >> updateCoder: anAnnouncement [
	coderContent removeChildren.
	coderContent addChild: anAnnouncement coder asElement
]
