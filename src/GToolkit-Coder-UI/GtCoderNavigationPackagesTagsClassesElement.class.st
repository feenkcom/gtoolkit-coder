Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationElement,
	#traits : 'TNavigationWithContextMenu',
	#classTraits : 'TNavigationWithContextMenu classTrait',
	#instVars : [
		'packagesList',
		'methodProtocolsList',
		'methodsLabel',
		'methodGroup',
		'methodGroupList',
		'protocolGroup',
		'slotsGroup',
		'slotsGroupList',
		'classesLabel'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> addPackage: aPackage [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> addPackage: aPackage tag: aPackageTag [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> browseHierarchyImplementorsOf: aSymbol [
	self phlow
		spawnObject: (GtSearchMethodsInClassFilter forClass: self selectedClass) withSuperclasses
				withSubclasses & aSymbol gtImplementors
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> browseHierarchyReferencesOf: aSymbol [
	self phlow
		spawnObject: (GtSearchMethodsInClassFilter forClass: self selectedClass) withSuperclasses
				withSubclasses & aSymbol gtSenders
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> browseImplementorsOf: aSymbol [
	self phlow spawnObject: (GtSearchImplementorsFilter selector: aSymbol)
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> browseReferencesOf: aSymbol [
	self phlow spawnObject: (GtSearchReferencesFilter literal: aSymbol) 
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> browseSlotReferencesFor: aString [
	self phlow
		spawnObject: (GtSearchInstanceSlotReferenceFilter
				forClassAndSubclasses: self selectedClass
				andVariable: aString)
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildCategorySlotTabs [
	| aTabGroup |
	aTabGroup := BrTabGroup new
			aptitude: BrGlamorousTabGroupAptitude - BrTabGroupSplitterAptitude;
			addTab: (BrTab new
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Categories' asRopedText glamorousCodeSmallSize;
					stencil: [ methodProtocolsList ]);
			addTab: (BrTab new
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Slots' asRopedText glamorousCodeSmallSize;
					stencil: [ slotsGroupList ]).

	^ aTabGroup
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildGroupList [
	^ BrGroupedList new
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ BrLabel new
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
		headerDataBinder: [ :label :each | label text: each domainObject asRopedText ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildGroupWithBinder: binderBlock onClick: clickBlock [
	| classGroup instanceGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance side';
			stream: #() asAsyncStream;
			itemStencil: [
				| aLabel |
				aLabel := BrLabel new.
				aLabel
					hMatchParent;
					vFitContent;
					beSmallSize;
					aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude +
						(BrGlamorousWithContextMenuAptitude
							content: [ GtCoderNavigationContextMenuContent new
									items: (self protocolListContextMenuItemsFor: (aLabel userData at: #protocol)) ]);
					when: BlClickEvent do: clickBlock.
				aLabel ];
			itemDataBinder: binderBlock;
			shouldShowWithoutItems: false.
	classGroup := instanceGroup copy domainObject: 'class side'.
	^ {instanceGroup.
		classGroup}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildMethodGroupList [
	| list |
	list := self buildGroupList.
	methodGroup := self
			buildMethodGroupWithBinder: [ :element :item | 
				element userData at: #method put: item.
				element text: item selector asRopedText. ]
			onClick: [ :event | 
				event consumed: true.
				self
					onMethodListSelectionChanged: (event currentTarget userData at: #method) ].
	list groups: methodGroup.
	^ list
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildMethodGroupWithBinder: binderBlock onClick: clickBlock [
	| classGroup instanceGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance side';
			stream: #() asAsyncStream;
			itemStencil: [ | aLabel |
				aLabel := BrLabel new.
				aLabel
					hMatchParent;
					vFitContent;
					beSmallSize;
					aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude +
						(BrGlamorousWithContextMenuAptitude
							content: [ GtCoderNavigationContextMenuContent new
									items: (self methodListContextMenuItemsFor: (aLabel userData at: #method)) ]);
					when: BlClickEvent do: clickBlock.
				aLabel ];
			itemDataBinder: binderBlock;
			shouldShowWithoutItems: false.
	classGroup := instanceGroup copy domainObject: 'class side'.
	^ {instanceGroup.
		classGroup}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildProtocolGroupList [
	| list |
	list := self buildGroupList.
	protocolGroup := self
			buildGroupWithBinder: [ :element :item | 
				element userData at: #protocol put: item.
				element text: item name asRopedText ]
			onClick: [ :event | 
				event consumed: true.
				self onProtocolListSelectionChanged ].
	list groups: protocolGroup.
	^ list
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildSlotGroupWithBinder: binderBlock onClick: clickBlock [
	| classSlotGroup instanceGroup classVarGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance slots';
			stream: #() asAsyncStream;
			itemStencil: [ BrHorizontalPane new
					aptitude:  BrGlamorousListItemAptitude;
					hMatchParent;
					vFitContent;
					when: BlClickEvent do: clickBlock ];
			itemDataBinder: binderBlock;
			shouldShowWithoutItems: false.
	classSlotGroup := instanceGroup copy domainObject: 'class slots'.
	classVarGroup := instanceGroup copy domainObject: 'class variables'.
	^ {instanceGroup.
		classSlotGroup.
		classVarGroup}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildSlotsGroupList [
	| list |
	list := self buildGroupList.
	slotsGroup := self
			buildSlotGroupWithBinder: [ :element :item | 
				| label |
				element removeChildren.
				label := BrLabel new
						hMatchParent;
						vFitContent;
						beSmallSize;
						aptitude: BrGlamorousLabelAptitude.
				label text: item name asRopedText.
				label
					addAptitude: (BrGlamorousWithContextMenuAptitude
							content: [ GtCoderNavigationContextMenuContent new
									items: (self slotListContextMenuItemsFor: item) ]).
				element addChild: label ]
			onClick: [ :event | 
				event consumed: true.
				self onSlotsListSelectionChanged ].
	list groups: slotsGroup.
	^ list
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> classMethodsForAProtocol: aSelectedItem [
	^ (self selectedClass class organization protocolNamed: aSelectedItem name)
		ifNotNil: [ :s | 
			(s methodSelectors
				collect: [ :sel | self selectedClass class >> sel ]
				thenReject: [ :meth | meth isFromTrait ]) asArray ]
		ifNil: [ #() ]
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> deselectPackages [
	packagesList deselectAll
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> emptyMethodProtocolList [
	methodProtocolsList initializeWithProtocols: #().
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> expandPackage: aRPackage [
	packagesList viewModel root
		allChildrenNodesBreadthFirstDo: [ :eachTreeNode |
			eachTreeNode value = aRPackage
				ifTrue: [ eachTreeNode expand ] ]
]

{ #category : #'private - testing' }
GtCoderNavigationPackagesTagsClassesElement >> hasPackageTagsIn: aRPackage [
	<return: #Boolean>
	| noTags noExtensions |
	noTags := (aRPackage classTags size = 1 and: [ aRPackage classTags anyOne name = aRPackage name ]).
	noExtensions := aRPackage extendedClasses isEmpty.
	^ noTags not or: [ noExtensions not ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> headerLabel [
	| label |
	label := BrLabel new.
	label
		aptitude: (BrGlamorousLabelAptitude new
				fontSize: 12;
				foreground: Color gray).
	^ label
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> hideClassList [
	classesLabel visibility: BlVisibility hidden.
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> hideOrShowClassList [
	classesList maxSelectionIndex isZero 
		ifTrue: [ self hideClassList ] 
		ifFalse: [ self showClassList ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeContent [
	super initializeContent.
	packagesList := GtCoderNavigationPackagesTreeElement new
			padding: (BlInsets right: 10).
	methodProtocolsList := self buildProtocolGroupList.
	slotsGroupList := self buildSlotsGroupList.
	methodGroupList := self buildMethodGroupList
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeElement [
	| pane1 pane2 pane3 pane4 |
	super initializeElement.
	pane1 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {self headerLabel text: 'Packages'.
					packagesList}.
	pane2 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {classesLabel := self headerLabel text: 'Classes'.
					classesList}.
	pane3 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {self buildCategorySlotTabs}.

	pane4 := BrVerticalPane new
			matchParent;
			addChildren: {methodsLabel := self headerLabel text: 'Methods'.
					methodGroupList}.
	self
		addChildren: {pane1.
				pane2.
				pane3.
				pane4}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeLayout [
	super initializeLayout.
	self layout: BlLinearLayout new beHorizontal.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> instanceMethodsForAProtocol: aSelectedItem [
	self selectedClass ifNil: [ ^ #() ].
	^ (self selectedClass organization protocolNamed: aSelectedItem name)
		ifNotNil: [ :s | s methodSelectors collect: [ :sel | self selectedClass >> sel ] as: Array ]
		ifNil: [ #() ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> methodList [
	^ methodGroup flatCollect: [ :grp | grp itemsProvider currentItems ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> methodListContextMenuItemsFor: item [
	^ {(self createLabel: 'Browse implementors' description: item selector)
			-> [ :elem | self browseImplementorsOf: item selector ].
		(self createLabel: 'Browse hierarachy implementors' description: item selector)
			-> [ :elem | self browseHierarchyImplementorsOf: item selector ].
		(self createLabel: 'Browse references' description: item selector)
			-> [ :elem | self browseReferencesOf: item selector ].
		(self createLabel: 'Browse hierarchy references' description: item selector)
			-> [ :elem | self browseHierarchyReferencesOf: item selector ].
		(self createLabel: 'Push up method' description: item selector)
			-> [ :elem | self pushUpMethod: item selector inElement: elem ].
		(self createLabel: 'Push down method' description: item selector)
			-> [ :elem | self pushDownMethod: item selector inElement: elem ].
		(self createLabel: 'Rename message' description: item selector)
			-> [ :elem | self renameMethod: item selector inElement: elem ].
		(self createLabel: 'Remove method' description: item selector)
			-> [ :elem | self removeMethod: item selector inElement: elem ]}
]

{ #category : #'private-accessing' }
GtCoderNavigationPackagesTagsClassesElement >> methodProtocolsList [
	^ methodProtocolsList
]

{ #category : #accessing }
GtCoderNavigationPackagesTagsClassesElement >> onClassRemoved: anAnnouncement [
	| aPackageOrTag |
	self
		inUIProcessDo: [ aPackageOrTag := self selectedPackageOrTag.
			packagesList deselectAll.
			self selectPackage: aPackageOrTag ]
]

{ #category : #accessing }
GtCoderNavigationPackagesTagsClassesElement >> onClassSelected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				selectClass: anAnnouncement theClass
				inPackage: anAnnouncement package
				tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onMethodChanged: anAnnouncement [
	self updateProtocolList
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> onMethodListSelectionChanged: aMethod [
	supressListChanges ifTrue: [ ^ self ].
	self navigationModel selectMethod: aMethod
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onMethodsCoderFiltersChanged: aGtCodersFiltersChanged [
	aGtCodersFiltersChanged source = self ifTrue: [ ^ self ].
	methodProtocolsList
		selectedItemDo: [ :aSelectedItem | 
			| aCategoryFilter |
			aCategoryFilter := GtSearchMethodCategoryFilter
					forCategory: aSelectedItem name.

			aGtCodersFiltersChanged filters
				do: [ :eachFilter | eachFilter = aCategoryFilter ifTrue: [ ^ self ] ] ].

	aGtCodersFiltersChanged filters
		do: [ :eachFilter | 
			eachFilter class = GtSearchMethodCategoryFilter
				ifTrue: [ methodProtocolsList items
						doWithIndex: [ :aProtocol :anIndex | 
							aProtocol name = eachFilter category
								ifTrue: [ self
										suppressListChangeEventsDuring: [ methodProtocolsList selectOne: anIndex ].
									^ self ] ] ] ].

	self suppressListChangeEventsDuring: [ methodProtocolsList deselectAll ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageListSelectionChanged [
	| anIndex aSelectedItem theIndices |
	supressListChanges ifTrue: [ ^ self ].
	theIndices := packagesList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: packagesList viewModel itemCount) ifFalse: [ ^ self ].
	aSelectedItem := (packagesList viewModel itemAt: anIndex) value.
	(aSelectedItem isKindOf: RPackage)
		ifTrue: [ self navigationModel selectPackage: aSelectedItem ]
		ifFalse: [ self navigationModel selectPackageTag: aSelectedItem ].
	self showClassList.
	self deselectClasses
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageRegistered: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self addPackage: anAnnouncement package ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageRenamed: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				renamePackage: anAnnouncement package
				oldName: anAnnouncement oldName
				newName: anAnnouncement newName ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package.
					self showClassList.
					self deselectClasses ] ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagAdded: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self addPackage: anAnnouncement package tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagRemoved: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self removePackage: anAnnouncement package tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagRenamed: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				renamePackageTag: anAnnouncement package
				oldName: anAnnouncement oldName
				newName: anAnnouncement newName ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package tag: anAnnouncer tag.
					self deselectClasses ] ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageUnregistered: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self removePackage: anAnnouncement package ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackagesSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self deselectPackages.
					self deselectClasses ] ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolListSelectionChanged [
	| aSelectedItem instMeths classMeths |
	slotsGroupList deselectAll.
	aSelectedItem := self selectedProtocol.
	aSelectedItem ifNil: [^self].
	self navigationModel selectMethodProtocol: aSelectedItem source: self.
	instMeths := self instanceMethodsForAProtocol: aSelectedItem.
	classMeths := self classMethodsForAProtocol: aSelectedItem.
	methodGroupList deselectAll.
	self updateMethodListWith: instMeths and: classMeths
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> onSlotsListSelectionChanged [
	| theIndices anIndex aSelectedItem instMeths classMeths |
	supressListChanges ifTrue: [ ^ self ].
	methodProtocolsList deselectAll.
	theIndices := slotsGroupList selectedIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: slotsGroupList viewModel entityCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (slotsGroupList viewModel entityAt: anIndex) value object.
	self navigationModel selectSlot: aSelectedItem source: self.
	instMeths := self selectedClass methodsAccessingSlot: aSelectedItem.
	classMeths := self selectedClass class methodsAccessingSlot: aSelectedItem.
	methodGroupList deselectAll.
	self updateMethodListWith: instMeths and: classMeths
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> protocolListContextMenuItemsFor: item [
	^ {(self createLabel: 'Remove ' description: item name)
			-> [ :elem | self removeProtocol: item name in: elem ].
		(self createLabel: 'Rename ' description: item name)
			-> [ :elem | self renameProtocol: item name in: elem ]}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> pushDownMethod: aSelector inElement: elem [
	| refactoring |
	refactoring := RBPushDownMethodRefactoring
			pushDown: {aSelector}
			from: self selectedClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateProtocolList
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> pushUpMethod: aSelector inElement: elem [
	| refactoring |
	refactoring := RBPullUpMethodRefactoring
			pullUp: {aSelector}
			from: self selectedClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateProtocolList
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> removeMethod: aSelector inElement: elem [
	| change button |
	change := RBRemoveMethodChange remove: aSelector from: self selectedClass.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change gtExecuteWithUndo ];
			changeStencil: [ GtPharoRemoveMethodPreviewStencil new
					selectorToRemove: aSelector;
					isEmptyMethod: false;
					anElement: self;
					create ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> removePackage: aPackage [
	| aSelectedPackageOrTag anIndex |
	anIndex := packagesList viewModel indexOf: aPackage.
	anIndex > 0 ifFalse: [ ^ self ].
	aSelectedPackageOrTag := self selectedPackageOrTag.

	self updatePackageLists.
	self
		reselectPackageOrTag: aSelectedPackageOrTag
		afterRemovalOfPackageNamed: aPackage name
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> removePackage: aPackage tag: aPackageTagName [
	| aSelectedPackageOrTag anIndex |
	anIndex := packagesList viewModel indexOf: aPackage.
	anIndex > 0 ifFalse: [ ^ self ].
	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].
	self updatePackageLists.
	self reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfTagNamed: aPackageTagName.
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> removeProtocol: protocolName in: elem [
	| refactoring |
	refactoring := RBRemoveProtocolChange
			removeProtocolNamed: protocolName
			in: self selectedClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateProtocolList
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> renameMethod: aSelector inElement: elem [
	| refactoring edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: aSelector;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenameMethodRefactoring
						renameMethod: aSelector
						in: self selectedClass
						to: aWish text asString
						permutation: (1 to: aSelector numArgs).
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> renamePackage: aPackage oldName: anOldName newName: aNewName [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> renamePackageTag: aPackageTag oldName: anOldName newName: aNewName [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> renameProtocol: protocolName in: elem [
	| refactoring edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: protocolName;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenameProtocolRefactoring
						renameProtocol: protocolName
						in: self selectedClass
						to: aWish text asString.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> renameSlot: slotName inElement: elem [
	| edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: slotName;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				| refactoring |
				refactoring := RBRenameInstanceVariableRefactoring
						rename: slotName
						to: aWish text asString
						in: self selectedClass.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateSlotList ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #'api - package reselections' }
GtCoderNavigationPackagesTagsClassesElement >> reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfPackageNamed: aRemovedPackageOrTagName [
	aSelectedPackageOrTag ifNotNil: [ 
		self deselectPackages.
		aSelectedPackageOrTag name = aRemovedPackageOrTagName
			ifTrue: [ 
				self hideClassList ]
			ifFalse: [ 
				self selectPackageOrTag: aSelectedPackageOrTag ] ]
]

{ #category : #'api - package reselections' }
GtCoderNavigationPackagesTagsClassesElement >> reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfTagNamed: aRemovedTagName [
	aSelectedPackageOrTag ifNotNil: [ 
		self deselectPackages.
		aSelectedPackageOrTag name = aRemovedTagName
			ifTrue: [ 
				self expandPackage: aSelectedPackageOrTag package.
				self hideClassList. ]
			ifFalse: [ 
				self selectPackageOrTag: aSelectedPackageOrTag ] ]
]

{ #category : #'api - class selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectClass: aClass inPackage: aPackage tag: aPackageTag [
	self selectedPackage ~= aPackage
		ifTrue: [ self selectPackage: aPackage tag: aPackageTag ].

	self selectClass: aClass.
	self updateProtocolList.
	self updateSlotList
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectPackage: aPackage [
	| aPreviousIndex |
	aPreviousIndex := packagesList selectedIndice.
	packagesList viewModel
		indexOf: aPackage
		do: [ :aNewIndex | 
			packagesList
				selectOne: aNewIndex;
				scrollToIndex:
					(self
						scrollIndexFromPrevious: aPreviousIndex
						current: aNewIndex
						max: packagesList viewModel itemCount) ].
	self updateClassLists.
	self hideOrShowClassList
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectPackage: aPackage tag: aPackageTag [
	| aPreviousIndex |
	(self hasPackageTagsIn: aPackage) ifFalse: [ ^ self selectPackage: aPackage ].
	aPackageTag isNil ifTrue: [ ^ self selectPackage: aPackage ].
	self expandPackage: aPackage.

	aPreviousIndex := packagesList selectedIndice.
	packagesList viewModel
		indexOf: aPackageTag
		do: [ :aNewIndex | 
			packagesList
				selectOne: aNewIndex;
				scrollToIndex: (self
						scrollIndexFromPrevious: aPreviousIndex
						current: aNewIndex
						max: packagesList viewModel itemCount) ].
	self updateClassLists.
	self hideOrShowClassList
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectPackageOrTag: aPackageOrTag [
	(aPackageOrTag isKindOf: RPackage)
		ifTrue: [ self selectPackage: aPackageOrTag ] 
		ifFalse: [ self selectPackage: aPackageOrTag package tag: aPackageOrTag ]
]

{ #category : #'api - class selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedClass [
	<return: #Class or: nil>
	^ classesList selectedClass
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackage [
	<return: #RPackage or: nil>
	^ packagesList selectedPackage
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackageNodeDo: aBlock [
	^ packagesList selectedPackageNodeDo: aBlock
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackageOrTag [
	| aSelectedPackageOrTag |
	packagesList selectedNodeDo: [ :aNode | aSelectedPackageOrTag := aNode value ].
	^ aSelectedPackageOrTag
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackageTag [
	<return: #RPackageTag or: nil>
	^ packagesList selectedPackageTag
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackageTagNodeDo: aBlock [
	^ packagesList selectedPackageTagNodeDo: aBlock
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> selectedProtocol [
	| theIndices anIndex |
	theIndices := methodProtocolsList selectedIndices ifEmpty: [ ^nil].
	anIndex := theIndices first.
	(anIndex between: 1 and: methodProtocolsList viewModel entityCount)
		ifFalse: [ ^nil ].
	^ (methodProtocolsList viewModel entityAt: anIndex) value object
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> showClassList [
	classesList visibility: BlVisibility visible.
	classesLabel visibility: BlVisibility visible
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> slotListContextMenuItemsFor: item [
	^ {(self createLabel: 'Browse references' description: item name)
			-> [ :elem | self browseSlotReferencesFor: item name ].
		(self createLabel: 'Push up' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBPullUpInstanceVariableRefactoring
						variable: item name
						class: self selectedClass superclass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ].
		(self createLabel: 'Push down' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := GtPushDownInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ].
		(self createLabel: 'Create accessors' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBCreateAccessorsForVariableRefactoring
						instanceVariable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ].
		(self createLabel: 'Abstract' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBAbstractInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ].
		(self createLabel: 'Protect' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBProtectInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ].
		(self createLabel: 'Remove' description: item name)
			-> [ :elem | 
				| refactoring |
				refactoring := RBRemoveInstanceVariableRefactoring
						variable: item name
						class: self selectedClass.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ].
		(self createLabel: 'Rename slot' description: item name)
			-> [ :elem | self renameSlot: item name inElement: elem ]}
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToPackageList.
	self subscribeToClassList.
	self subscribeToProtocolList.
	self subscribeToSlotList.
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToNavigationModel [
	| subscriptions |
	self hasNavigationModel ifFalse: [ ^ self ].
	super subscribeToNavigationModel.
	subscriptions := {GtCoderNavigationPackagesSelected -> #onPackagesSelected:.
			GtCoderNavigationPackageSelected -> #onPackageSelected:.
			GtCoderNavigationPackageTagSelected -> #onPackageTagSelected:.
			GtCoderNavigationPackageRegistered -> #onPackageRegistered:.
			GtCoderNavigationPackageUnregistered -> #onPackageUnregistered:.
			GtCoderNavigationPackageRenamed -> #onPackageRenamed:.
			GtCoderNavigationPackageTagAdded -> #onPackageTagAdded:.
			GtCoderNavigationPackageTagRemoved -> #onPackageTagRemoved:.
			GtCoderNavigationPackageTagRenamed -> #onPackageTagRenamed:.
			GtCodersFiltersChanged -> #onMethodsCoderFiltersChanged:.
			GtCoderNavigationMethodModification -> #onMethodChanged:}.
	subscriptions
		do: [ :sub | 
			navigationModel weak
				when: sub key
				send: sub value
				to: self ]
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToPackageList [
	packagesList
		when: BrSelectionChanged
		do: [ :anEvent | self onPackageListSelectionChanged ]
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToProtocolList [
	methodProtocolsList
		when: BrSelectionChanged
		do: [ :anEvent | self onProtocolListSelectionChanged ]
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToSlotList [
	slotsGroupList
		when: BrSelectionChanged
		do: [ :anEvent | self onSlotsListSelectionChanged ]
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateClassLists [
	self hasNavigationModel ifFalse: [ ^ self ].
	classesList initializeWithClasses: navigationModel classesToShow.
	self updateProtocolList.
	self updateSlotList
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateContent [
	self updatePackageAndClassLists.
	self updateSelections.
	self hideOrShowClassList
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateMethodListWith: instanceMethods and: classMethods [
	| instMethStream classMethStream |
	methodGroupList deselectAll.
	instMethStream := instanceMethods
			asSortedCollection: [ :a :b | a selector < b selector ].

	classMethStream := classMethods
			asSortedCollection: [ :a :b | a selector < b selector ].

	methodGroup
		with: {instMethStream.
				classMethStream}
		do: [ :grp :str | grp items: str ].

	methodGroupList groups: methodGroup
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updatePackageAndClassLists [
	self updatePackageLists.
	self updateClassLists.
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updatePackageLists [
	self hasNavigationModel ifFalse: [ ^ self ].
	packagesList initializeWithPackages: navigationModel packagesToShow.
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateProtocolList [
	| methodProtocols classProtocols extension |
	navigationModel hasSelectedClass
		ifFalse: [ self updateProtocolListWith: #() and: #().
			self updateMethodListWith: #() and: #().
			methodProtocolsList visibility: BlVisibility hidden.
			methodsLabel visibility: BlVisibility hidden.
			^ self ].
	classProtocols := navigationModel selectedClass class organization protocols
			reject: [ :prot | 
				(navigationModel selectedClass class methods
					select: [ :meth | (prot includesSelector: meth selector) and: [ meth isFromTrait not ] ])
					isEmpty ].
	methodProtocols := navigationModel selectedClass organization protocols.
	extension := false.
	navigationModel
		selectedPackageDo: [ :pkg | 
			pkg ~= navigationModel selectedClass package
				ifTrue: [ | protocolName |
					extension := true.
					protocolName := '*' , pkg name.
					methodProtocols := methodProtocols
							select: [ :each | each name beginsWith: protocolName ].
					classProtocols := classProtocols
							select: [ :each | each name beginsWith: protocolName ] ] ].
	self updateProtocolListWith: methodProtocols and: classProtocols.
	extension
		ifTrue: [ methodProtocolsList selectOne: 2.
			self onProtocolListSelectionChanged ]
		ifFalse: [ self
				updateMethodListWith: navigationModel selectedClass methods
				and: (navigationModel selectedClass class methods
						reject: [ :meth | meth isFromTrait ]) ].
	methodProtocolsList visibility: BlVisibility visible.
	methodsLabel visibility: BlVisibility visible
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateProtocolListWith: instanceProtocols and: classProtocols [
	| instStream classStream |
	methodProtocolsList deselectAll.
	instStream := instanceProtocols
			asSortedCollection: [ :a :b | a name < b name ].

	classStream := classProtocols
			asSortedCollection: [ :a :b | a name < b name ].

	protocolGroup
		with: {instStream.
				classStream}
		do: [ :grp :str | grp items: str ].

	methodProtocolsList groups: protocolGroup
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSelections [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedPackage
		ifTrue: [ navigationModel hasSelectedClass
				ifTrue: [ self
						selectClass: navigationModel selectedClass
						inPackage: navigationModel selectedPackage
						tag: navigationModel selectedTag ]
				ifFalse: [ self
						selectPackage: navigationModel selectedPackage
						tag: navigationModel selectedTag ] ]
]

{ #category : #'api - class selections' }
GtCoderNavigationPackagesTagsClassesElement >> updateSlotList [
	| slotStream classSlotStream classVarStream streams |
	slotsGroupList deselectAll.
	navigationModel hasSelectedClass
		ifTrue: [ slotStream := navigationModel selectedClass instanceVariables.
			classSlotStream := navigationModel selectedClass class instanceVariables.
			classVarStream := navigationModel selectedClass classVariables.
			streams := {slotStream.
					classSlotStream.
					classVarStream}
					collect: [ :each | each asSortedCollection: [ :a :b | a name < b name ] ] ]
		ifFalse: [ streams := {#().
					#().
					#()} ].
	slotsGroup with: streams do: [ :grp :str | grp items: str ].
	slotsGroupList groups: slotsGroup
]
