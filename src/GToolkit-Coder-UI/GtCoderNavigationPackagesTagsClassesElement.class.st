Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationElement,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'packagesList',
		'methodProtocolsList',
		'methodsLabel',
		'methodGroupList',
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
GtCoderNavigationPackagesTagsClassesElement >> buildCategorySlotTabs [
	| aTabGroup |
	aTabGroup := BrTabGroup new
			aptitude: BrGlamorousTabGroupProportionalAptitude - BrTabGroupSplitterAptitude;
			addTab: (BrTab new
					hMatchParent;
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Categories' asRopedText glamorousCodeSmallSize;
					stencil: [ methodProtocolsList ]);
			addTab: (BrTab new
					hMatchParent;
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
GtCoderNavigationPackagesTagsClassesElement >> buildMethodGroupList [
	^ GtCoderMethodsGroupedListElement new
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildProtocolGroupList [
	^ GtCoderProtocolsGroupedListElement new
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildSlotsGroupList [
	^ GtCoderSlotsGroupedListElement new
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> deselectPackages [
	packagesList deselectAll
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

{ #category : #'private - accessing' }
GtCoderNavigationPackagesTagsClassesElement >> methodProtocolsList [
	^ methodProtocolsList
]

{ #category : #'event handling - selection' }
GtCoderNavigationPackagesTagsClassesElement >> onClassDeselected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self deselectClass: anAnnouncement theClass ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onClassRemoved: anAnnouncement [
	| aPackageOrTag |
	self
		inUIProcessDo: [ aPackageOrTag := self selectedPackageOrTag.
			packagesList deselectAll.
			self selectPackage: aPackageOrTag ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationPackagesTagsClassesElement >> onClassSelected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self selectClass: anAnnouncement theClass ]
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
GtCoderNavigationPackagesTagsClassesElement >> onNavigationModelChanged [
	slotsGroupList navigationModel: self navigationModel.
	methodGroupList navigationModel: self navigationModel.

	super onNavigationModelChanged
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
	self inUIProcessDo: [ self suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package ] ]
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

{ #category : #'event handling - selection' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package tag: anAnnouncer tag.
					"self deselectClasses" ] ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageUnregistered: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self removePackage: anAnnouncement package ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationPackagesTagsClassesElement >> onPackagesSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self deselectPackages.
					self deselectClasses ] ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolDeselected: anAnnouncement [
	methodProtocolsList deselectProtocol
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolListSelectionChanged [
	| aSelectedItem |
	slotsGroupList deselectAll.
	aSelectedItem := methodProtocolsList selectedProtocol.
	aSelectedItem ifNil: [^self].
	self navigationModel selectProtocol: aSelectedItem source: self.
	"methodGroupList deselectAll.
	self updateMethodListWith: self navigationModel methodsToShow."
]

{ #category : #'event handling - selection' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolSelected: anAnnouncement [
	methodProtocolsList selectProtocol: anAnnouncement protocol
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolsToShowChanged: anAnnouncement [
	self hasNavigationModel
		ifFalse: [ ^ self ].
	
	methodProtocolsList updateProtocolListWith: self navigationModel protocolsToShow.

	self navigationModel selectedProtocol
		ifNil: [ methodProtocolsList deselectProtocol ]
		ifNotNil: [ :aProtocol | methodProtocolsList selectProtocol: aProtocol ]
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
	aSelectedPackageOrTag
		ifNotNil: [ self deselectPackages.
			(aSelectedPackageOrTag name sameContentAs: aRemovedTagName)
				ifTrue: [ self expandPackage: aSelectedPackageOrTag package.
					self hideClassList ]
				ifFalse: [ self selectPackageOrTag: aSelectedPackageOrTag ] ]
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

	self expandPackage: aPackage.
	aPreviousIndex := packagesList selectedIndice.
	
	packagesList deselectAll.
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
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectPackage: aPackage tag: aPackageTag [
	| aPreviousIndex |
	(self hasPackageTagsIn: aPackage) ifFalse: [ ^ self selectPackage: aPackage ].
	aPackageTag isNil ifTrue: [ ^ self selectPackage: aPackage ].
	
	packagesList deselectAll.
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
						max: packagesList viewModel itemCount) ]
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

{ #category : #'private - accessing' }
GtCoderNavigationPackagesTagsClassesElement >> selectedProtocol [
	^ self navigationModel selectedProtocol
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> showClassList [
	classesList visibility: BlVisibility visible.
	classesLabel visibility: BlVisibility visible
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToPackageList.
	self subscribeToClassList.
	self subscribeToProtocolList.
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToNavigationModel [
	| subscriptions |
	self hasNavigationModel ifFalse: [ ^ self ].
	super subscribeToNavigationModel.
	subscriptions := {
			GtCoderNavigationPackagesSelected -> #onPackagesSelected:.
			GtCoderNavigationPackageSelected -> #onPackageSelected:.
			GtCoderNavigationPackageTagSelected -> #onPackageTagSelected:.
			GtCoderNavigationPackageRegistered -> #onPackageRegistered:.
			GtCoderNavigationPackageUnregistered -> #onPackageUnregistered:.
			GtCoderNavigationPackageRenamed -> #onPackageRenamed:.
			GtCoderNavigationPackageTagAdded -> #onPackageTagAdded:.
			GtCoderNavigationPackageTagRemoved -> #onPackageTagRemoved:.
			GtCoderNavigationPackageTagRenamed -> #onPackageTagRenamed:.
			"Announcement when items selected"
			"GtCoderNavigationClassSelected -> #onClassSelected:. <--- defined in the superclass"
			GtCoderNavigationProtocolSelected -> #onProtocolSelected:.
			GtCoderNavigationProtocolDeselected -> #onProtocolDeselected:.
			"Announcements when we need to update items in the lists"
			GtCoderNavigationProtocolsToShowChanged -> #onProtocolsToShowChanged:.
			GtCodersFiltersChanged -> #onMethodsCoderFiltersChanged:.
	}.
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

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateClassList [
	self hasNavigationModel
		ifFalse: [ ^ self ].
	
	classesList initializeWithClasses: navigationModel classesToShow.
	
	navigationModel selectedClass
		ifNotNil: [ :aClass | self selectClass: aClass ]
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateContent [
	self updatePackageLists.
	self updateClassList.
	self updateProtocolList.
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updatePackageLists [
	self hasNavigationModel
		ifFalse: [ ^ self ].
	
	packagesList initializeWithPackages: navigationModel packagesToShow.

	navigationModel selectedPackage
		ifNotNil: [ :aPackage | self selectPackage: aPackage tag: navigationModel selectedTag ]
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateProtocolList [
	self hasNavigationModel
		ifFalse: [ ^ self ].
	
	methodProtocolsList navigationModel: self navigationModel.
	methodProtocolsList updateProtocolListWith: self navigationModel protocolsToShow.
	
	self navigationModel selectedProtocol
		ifNotNil: [ :aProtocol | methodProtocolsList selectProtocol: aProtocol ]
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

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSlotList [
	slotsGroupList updateSlotList
]
