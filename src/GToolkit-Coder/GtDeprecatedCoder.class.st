Class {
	#name : #GtDeprecatedCoder,
	#superclass : #BlElement,
	#traits : 'TGtPagerPageInstantiator + TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPagerPageInstantiator classTrait + TGtPhlowToolDetailAdjustable classTrait',
	#instVars : [
		'coderContent',
		'navigationModel',
		'sidebarElement'
	],
	#category : #'GToolkit-Coder-! Core'
}

{ #category : #'instance creation' }
GtDeprecatedCoder class >> forClass: aClass [
	^ self forCoder: (GtClassCoder forClass: aClass)
]

{ #category : #'instance creation' }
GtDeprecatedCoder class >> forCoder: aCoder [
	^ self basicNew initialize pushCoder: aCoder
]

{ #category : #'instance creation' }
GtDeprecatedCoder class >> forMethod: aCompiledMethod [
    | classCoder coder |
    classCoder := GtClassCoder forClass: aCompiledMethod methodClass instanceSide.
    coder := self forCoder: classCoder.
    classCoder withSelectedMethod: aCompiledMethod.
    ^ coder
]

{ #category : #'instance creation' }
GtDeprecatedCoder class >> forObject: anObject [
	^ self forCoder: (GtClassCoder forObject: anObject)
]

{ #category : #'instance creation' }
GtDeprecatedCoder class >> forPackage: anRPackage [
	^ self forCoder: (GtPackageCoder forPackage: anRPackage)
]

{ #category : #testing }
GtDeprecatedCoder class >> isDeprecated [
	^ true
]

{ #category : #'instance creation' }
GtDeprecatedCoder class >> new [
	^ self forCoder: GtPackagesCoder new
]

{ #category : #'private - ui' }
GtDeprecatedCoder >> addClassTab: look [
	<gtCreateComponentTab: 10>
	^ BrTab new
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
			element ]
]

{ #category : #'private - ui' }
GtDeprecatedCoder >> addPackageTab: look [
	<gtCreateComponentTab: 30>
	^ BrTab new
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
			element ]
]

{ #category : #'private - ui' }
GtDeprecatedCoder >> addTraitTab: look [
	<gtCreateComponentTab: 20>
	^ BrTab new
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
			element ]
]

{ #category : #'private - ui' }
GtDeprecatedCoder >> buildAddButton [
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
GtDeprecatedCoder >> buildAddInterface: look [
	| contentTabs tabMethods |
	contentTabs := BrTabGroup new.
	contentTabs look: BrGlamorousTabGroupLook new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tabMethods := (Pragma allNamed: #gtCreateComponentTab: in: self class)
		asSortedCollection: [ :a :b | a arguments first < b arguments first ].
	tabMethods
		do:
			[ :each | contentTabs addTab: (self perform: each method selector with: look) ].
	^ contentTabs
]

{ #category : #'private - ui' }
GtDeprecatedCoder >> buildClassLabel [
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
GtDeprecatedCoder >> buildHierarchyButton [
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
GtDeprecatedCoder >> buildHorizontalPane [
	^ BrHorizontalPane new
		hFitContent;
		vMatchParent
]

{ #category : #'private - ui' }
GtDeprecatedCoder >> buildSpotterButton [
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
GtDeprecatedCoder >> buildToolbar [
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
GtDeprecatedCoder >> initialize [
	super initialize.
	self initializeListeners.
	self initializeToolVolumeModel.
	self initializeNavigationModel.
	self initializeMainContent.
	self initializeSidebarElement.
	self initializeElement.
]

{ #category : #initialization }
GtDeprecatedCoder >> initializeElement [
	| aHorizontalPane |
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	aHorizontalPane := BrHorizontalPane new
		matchParent;
		addChild: sidebarElement;
		addChild: coderContent.

	self addChild: aHorizontalPane.
	self addChild: self buildToolbar
]

{ #category : #initialization }
GtDeprecatedCoder >> initializeListeners [
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
GtDeprecatedCoder >> initializeMainContent [
	coderContent := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #initialization }
GtDeprecatedCoder >> initializeNavigationModel [
	navigationModel := GtCoderNavigationPackagesTagsClassesModel new.
	navigationModel when: GtCoderNavigationSelectionAnnouncement send: #updateCoder: to: self.
	
]

{ #category : #initialization }
GtDeprecatedCoder >> initializeSidebarElement [
	sidebarElement := GtPhlowHorizontalSidebarElement new
		contentStencil: (GtCoderNavigationTabsStencil new 
			navigationModel: navigationModel).
	self addLook: (GtPhlowToolDetailLook new
		normal: [ :theInstance | sidebarElement hide ];
		detailed: [ :theInstance | sidebarElement show ]).
]

{ #category : #initialization }
GtDeprecatedCoder >> initializeToolVolumeModel [
	self addInteractiveModelState: GtPhlowToolDetailModel new.
]

{ #category : #'hooks - children' }
GtDeprecatedCoder >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	navigationModel subscribeToSystem.
]

{ #category : #'hooks - children' }
GtDeprecatedCoder >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	navigationModel unsubscribeFromSystem.
]

{ #category : #opening }
GtDeprecatedCoder >> pagerWindowTitle [
	<return: #String>
	^ 'Coder'
]

{ #category : #'api - coder' }
GtDeprecatedCoder >> pushCoder: aCoderOrCoders [
	navigationModel selectCoder: aCoderOrCoders
]

{ #category : #'api - spawning' }
GtDeprecatedCoder >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	self pushCoder: aGtCoderToReplaceEvent coder
]

{ #category : #'api - spawning' }
GtDeprecatedCoder >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	self phlow spawnTool: (GtReadyCoderTool coder: (aGtCoderToSpawnEvent coder))
]

{ #category : #'api - spawning' }
GtDeprecatedCoder >> spawnInSpaceFrom: aGtCoderToSpawnInSpaceEvent [
	aGtCoderToSpawnInSpaceEvent consumed: true.
	
	
]

{ #category : #'api - spawning' }
GtDeprecatedCoder >> updateCoder: anAnnouncement [
	coderContent removeChildren.
	coderContent addChild: anAnnouncement coder asElement
]
