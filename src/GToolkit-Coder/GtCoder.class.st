"
I am the entrance point into the coder as a tool
"
Class {
	#name : #GtCoder,
	#superclass : #BlElement,
	#traits : 'TGtPagerPageInstantiator + TGtPhlowToolVolumeAdjustable',
	#classTraits : 'TGtPagerPageInstantiator classTrait + TGtPhlowToolVolumeAdjustable classTrait',
	#instVars : [
		'coderContent',
		'navigationModel',
		'leftSideBarContent',
		'leftSideBarResizer'
	],
	#category : #'GToolkit-Coder-! Core'
}

{ #category : #'instance creation' }
GtCoder class >> forClass: aClass [
	^ self forCoder: (GtClassCoder forClass: aClass)
]

{ #category : #'instance creation' }
GtCoder class >> forCoder: aCoder [
	^ self basicNew initialize pushCoder: aCoder
]

{ #category : #'instance creation' }
GtCoder class >> forMethod: aCompiledMethod [
    | classCoder coder |
    classCoder := GtClassCoder forClass: aCompiledMethod methodClass instanceSide.
    coder := self forCoder: classCoder.
    classCoder withSelectedMethod: aCompiledMethod.
    ^ coder
]

{ #category : #'instance creation' }
GtCoder class >> forObject: anObject [
	^ self forCoder: (GtClassCoder forObject: anObject)
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
GtCoder >> buildAddButton [
	| look |
	^ BrButton new
		label: 'Add class or package';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousVectorIcons add;
								yourself ]
						content: [ | element |
							element := BlElement new.
							element
								constraintsDo: [ :c | 
									c horizontal exact: 400.
									c vertical exact: 300 ].
							element addChild: (self buildAddInterface: look).
							element ]);
		icon: BrGlamorousVectorIcons add;
		yourself
]

{ #category : #'private - ui' }
GtCoder >> buildAddInterface: look [
	| contentTabs tab |
	contentTabs := BrTabGroup new.
	contentTabs look: BrGlamorousTabGroupLook new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tab := BrTab new
		look: BrGlamorousTabLook new;
		label: 'Class';
		stencil: [ | element |
			element := GtCreateBehaviorElement new.
			element
				behaviorBlock: [ :cls | 
					look hide.
					navigationModel selectClass: cls ].
			element forClassDefinition.
			navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel
				selectedTagDo: [ :tag | element forPackageTag: tag ].
			navigationModel
				selectedClassDo: [ :cls | 
					cls isTrait
						ifFalse: [ element forSuperclass: cls ] ].
			element ].
	contentTabs addTab: tab.
	tab := BrTab new
		look: BrGlamorousTabLook new;
		label: 'Trait';
		stencil: [ | element |
			element := GtCreateBehaviorElement new.
			element
				behaviorBlock: [ :cls | 
					look hide.
					navigationModel selectClass: cls ].
			element forTraitDefinition.
			navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel
				selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ].
	contentTabs addTab: tab.
	tab := BrTab new
		look: BrGlamorousTabLook new;
		label: 'Package';
		stencil: [ | element |
			element := GtCreatePackageElement new.
			element
				packageBlock: [ :pkg :tag | 
					look hide.
					tag isNil 
						ifTrue: [ navigationModel selectPackage: pkg ]
						ifFalse: [ navigationModel selectPackageTag: tag ] ].
			navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			element ].
	contentTabs addTab: tab.
	^ contentTabs
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
					look: BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook - BrGlamorousButtonExteriorLook;
					icon: BrGlamorousIcons tree;
					yourself ]
			content: [
				BlElement new
					size: 400@400;
					addChild: (GtCoderNavigationTabsStencil new 
						navigationModel: navigationModel;
						asElement)
			]);
		icon: BrGlamorousIcons tree asElement;
		yourself
]

{ #category : #'private - ui' }
GtCoder >> buildHorizontalPane [
	^ BrHorizontalPane new
		hFitContent;
		vMatchParent
]

{ #category : #'private - ui' }
GtCoder >> buildSpotterButton [
	<return: #BrButton>
	
	^ GtSpotterDropdownButtonStencil new
		valuable: (GtCoderSpotterStart new navigationModel: navigationModel);
		tooltip: 'Search Code';
		actOn: [ :anActOnEvent :anItem :theButton | 
			| acted |
			acted := false.
			(anItem isKindOf: RPackage) ifTrue: [ 
				navigationModel selectPackage: anItem. acted := true ].
			(anItem isKindOf: ClassDescription) ifTrue: [ 
				navigationModel selectClass: anItem. acted := true ].
			(anItem isKindOf: CompiledMethod) ifTrue: [ 
				navigationModel selectMethod: anItem. acted := true ].
			acted ifTrue: [ anActOnEvent beActed ] ];
		asElement.
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
		addItem: self buildAddButton;
		yourself
]

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	self initializeListeners.
	self initializeToolVolumeModel.
	self initializeNavigationModel.
	self initializeMainContent.
	self initializeLeftSideBarContent.
	self initializeElement.
]

{ #category : #initialization }
GtCoder >> initializeElement [
	| aHorizontalPane |
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	aHorizontalPane := BrHorizontalPane new
		matchParent;
		addChild: leftSideBarContent;
		addChild: coderContent.

	self addChild: aHorizontalPane.
	self addChild: self buildToolbar
]

{ #category : #initialization }
GtCoder >> initializeLeftSideBarContent [
	leftSideBarContent := BlElement new
		layout: BlFrameLayout new;
		look: (BrGlamorousWithHorizontalResizerLook new 
			resizerDo: [ :theResizer | leftSideBarResizer := theResizer ]);
		visibility: BlVisibility gone;
		constraintsDo: [ :c |
			c horizontal exact: 0.
			c vertical matchParent ].
]

{ #category : #initialization }
GtCoder >> initializeListeners [
	self
		when: GtCoderToReplace
		do: [ :anEvent | self replaceFrom: anEvent ].

	self
		when: GtCoderToSpawn
		do: [ :anEvent | self spawnFrom: anEvent ].

	self
		when: GtCoderToSpawnInSpace
		do: [ :anEvent | self spawnInSpaceFrom: anEvent ].
]

{ #category : #initialization }
GtCoder >> initializeMainContent [
	coderContent := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #initialization }
GtCoder >> initializeNavigationModel [
	navigationModel := GtCoderNavigationPackagesTagsClassesModel new.
	navigationModel when: GtCoderNavigationSelectionAnnouncement send: #updateCoder: to: self.
	
]

{ #category : #initialization }
GtCoder >> initializeToolVolumeModel [
	self addInteractiveModelState: GtPhlowToolVolumeModel new.
]

{ #category : #'api - configuration' }
GtCoder >> leftSideBarDo: aBlock [
	aBlock value: leftSideBarContent
]

{ #category : #'api - configuration' }
GtCoder >> leftSideBarResizerDo: aBlock [
	aBlock value: leftSideBarResizer
]

{ #category : #'instance creation' }
GtCoder >> newEmbellisherExtension [
	^ GtPagerPageEmbellisherExtensions new 
		addExtension: (GtCoderEmbeddedPlaygroundExtension new
			navigationModel: navigationModel);
		addExtension: (GtCoderSideBarSystemNavigationExtension new
			coder: self
			sideBar: leftSideBarContent
			navigationModel: navigationModel)
]

{ #category : #'hooks - children' }
GtCoder >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	navigationModel subscribeToSystem.
]

{ #category : #'hooks - children' }
GtCoder >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	navigationModel unsubscribeFromSystem.
]

{ #category : #opening }
GtCoder >> pagerWindowTitle [
	<return: #String>
	^ 'Coder'
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
	
	self phlow spawnTool: (GtReadyCoderTool coder: (aGtCoderToSpawnEvent coder))
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
