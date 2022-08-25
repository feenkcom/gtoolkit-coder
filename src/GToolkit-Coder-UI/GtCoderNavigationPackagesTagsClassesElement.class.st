Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationElement,
	#instVars : [
		'packagesList',
		'classesLabel',
		'methodProtocolsList',
		'classAndMethodProtocolList',
		'protocolLabel',
		'coderFilterChangesSubscription',
		'methodsLabel',
		'methodGroup',
		'methodGroupList'
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
GtCoderNavigationPackagesTagsClassesElement >> buildMethodGroupList [
	| menu instanceGroup classGroup |
	menu := BrGroupedList new
			padding: (BlInsets left: 5 right: 10);
			matchParent;
			headerElementStencil: [ BrLabel new
					beSmallSize;
					aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
			headerDataBinder: [ :label :each | label text: each domainObject asRopedText ].

	instanceGroup := BrGroup new
			domainObject: 'instance side';
			stream: #() asAsyncStream;
			itemStencil: [ | label |
				label := BrLabel new
						hMatchParent;
						vFitContent;
						beSmallSize;
						aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude
								+ (BrStyleCommonAptitude new
										hovered: [ :aStyle | aStyle background: self theme item selectedColor ]);
						when: BlClickEvent
							do: [ :event | 
								event consumed: true.
								self onMethodListSelectionChanged: (label userData at: #method) ] ];
			itemDataBinder: [ :label :item | 
				label text: item selector asRopedText.
				label userData at: #method put: item.
				label ];
			shouldShowWithoutItems: false.
	classGroup := instanceGroup copy domainObject: 'class side'.
	methodGroup := {instanceGroup.
			classGroup}.
	menu stream: methodGroup asAsyncStream.

	^ menu
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

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> hideClassList [
	classAndMethodProtocolList visibility: BlVisibility hidden.
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

	methodProtocolsList := GtCoderNavigationMethodProtocolListElement new
			matchParent.

	classAndMethodProtocolList := BrVerticalPane new
			matchParent;
			addChild: classesList;
			addChild: (protocolLabel := BrLabel new
						aptitude: (BrGlamorousLabelAptitude new
								fontSize: 12;
								foreground: Color gray);
						text: 'Categories');
			addChild: methodProtocolsList.

	methodGroupList := self buildMethodGroupList
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeElement [
	| pane1 pane2 pane3 |
	super initializeElement.
	pane1 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {BrLabel new
						aptitude: (BrGlamorousLabelAptitude new
								fontSize: 12;
								foreground: Color gray);
						text: 'Packages'.
					packagesList}.
	pane2 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {classesLabel := BrLabel new
							aptitude: (BrGlamorousLabelAptitude new
									fontSize: 12;
									foreground: Color gray);
							text: 'Classes'.
					classAndMethodProtocolList}.
	pane3 := BrVerticalPane new
			matchParent;
			addChildren: {methodsLabel := BrLabel new
							aptitude: (BrGlamorousLabelAptitude new
									fontSize: 12;
									foreground: Color gray);
							text: 'Methods'.
					methodGroupList}.
	self
		addChildren: {pane1.
				pane2.
				pane3}
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

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> methodList [
	^methodGroup flatCollect: [:grp | grp itemsProvider currentItems]
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTagsClassesElement >> methodProtocolsList [
	^methodProtocolsList
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
	
	methodProtocolsList selectedItemDo: [ :aSelectedItem | 
		| aCategoryFilter |
		aCategoryFilter := GtSearchMethodCategoryFilter forCategory: aSelectedItem.
		
		aGtCodersFiltersChanged filters do: [ :eachFilter | 
			eachFilter = aCategoryFilter ifTrue: [ 
				^ self ] ] ].
			
	aGtCodersFiltersChanged filters do: [ :eachFilter | 
		eachFilter class = GtSearchMethodCategoryFilter ifTrue: [
			methodProtocolsList items
				doWithIndex: [ :aProtocol :anIndex | 
					(aProtocol name = eachFilter category) ifTrue: [ 
						self suppressListChangeEventsDuring: [
							methodProtocolsList selectOne: anIndex ].
						^ self ] ] ] ].
	
	self suppressListChangeEventsDuring: [
		methodProtocolsList deselectAll ].
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
		ifFalse: [ self navigationModel selectTag: aSelectedItem ].
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
		suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package.
			self showClassList.
			self deselectClasses ]
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
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagSelected: anAnnouncer [
	self
		suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package tag: anAnnouncer tag.
			self deselectClasses ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageUnregistered: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self removePackage: anAnnouncement package ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackagesSelected: anAnnouncer [
	self
		suppressListChangeEventsDuring: [ self deselectPackages.
			self deselectClasses ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolListSelectionChanged [
	| anIndex aSelectedItem theIndices instMeths classMeths |
	supressListChanges ifTrue: [ ^ self ].
	theIndices := methodProtocolsList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: methodProtocolsList viewModel itemCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (methodProtocolsList viewModel itemAt: anIndex) value.
	self navigationModel selectMethodProtocol: aSelectedItem source: self.
	instMeths := (self selectedClass organization protocolNamed: aSelectedItem)
			ifNotNil: [ :s | s methodSelectors collect: [ :sel | self selectedClass >> sel ] as: Array ]
			ifNil: [ #() ].
	classMeths := (self selectedClass class organization
			protocolNamed: aSelectedItem)
			ifNotNil: [ :s | 
				(s methodSelectors
					collect: [ :sel | self selectedClass class >> sel ]
					thenReject: [ :meth | meth isFromTrait ]) asArray ]
			ifNil: [ #() ].
	methodGroupList deselectAll.
	self updateMethodListWith: instMeths and: classMeths
]

{ #category : #'api - package updates' }
GtCoderNavigationPackagesTagsClassesElement >> removePackage: aPackage [
	| aSelectedPackageOrTag anIndex |

	anIndex := packagesList viewModel indexOf: aPackage.
	anIndex > 0 ifFalse: [ ^ self ].
		
	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	self reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfPackageNamed: aPackage name.
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
	(self selectedPackage ~= aPackage
		or: [ self selectedPackageTag ~= aPackageTag ])
		ifTrue: [ self selectPackage: aPackage tag: aPackageTag ].
	self selectClass: aClass
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

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackageTag [
	<return: #RPackageTag or: nil>
	^ packagesList selectedPackageTag
]

{ #category : #'api - package selections' }
GtCoderNavigationPackagesTagsClassesElement >> selectedPackageTagNodeDo: aBlock [
	^ packagesList selectedPackageTagNodeDo: aBlock
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> showClassList [
	classAndMethodProtocolList visibility: BlVisibility visible.
	classesLabel visibility: BlVisibility visible.
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToPackageList.
	self subscribeToClassList.
	self subscribeToProtocolList
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
		do: [ :anEvent | self onProtocolListSelectionChanged ].
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateClassLists [
	self hasNavigationModel ifFalse: [ ^ self ].
	classesList initializeWithClasses: navigationModel classesToShow.
	self updateProtocolList
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateContent [
	self updatePackageAndClassLists.
	self updateSelectedPackageAndTag.
	self updateSelectedClass.
	self hideOrShowClassList
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateMethodListWith: instanceMethods and: classMethods [
	| instMethStream classMethStream |
	methodGroupList deselectAll.
	instMethStream := (instanceMethods
			asSortedCollection: [ :a :b | a selector < b selector ]) asAsyncStream.

	classMethStream := (classMethods
			asSortedCollection: [ :a :b | a selector < b selector ]) asAsyncStream.

	methodGroup
		with: {instMethStream.
				classMethStream}
		do: [ :grp :str | grp stream: str ].

	methodGroupList stream: methodGroup asAsyncStream
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
	| methodProtocols |
	methodProtocolsList deselectAll.

	navigationModel hasSelectedClass
		ifTrue: [ | classProtocols |
			classProtocols := navigationModel selectedClass class organization protocols
					reject: [ :prot | 
						(self selectedClass class methods
							select: [ :meth | (prot includesSelector: meth selector) and: [ meth isFromTrait not ] ])
							isEmpty ].
			methodProtocols := navigationModel selectedClass organization protocols
					, classProtocols.
			methodProtocolsList initializeWithProtocols: methodProtocols.
			methodProtocolsList visibility: BlVisibility visible.
			self
				updateMethodListWith: navigationModel selectedClass methods
				and: (navigationModel selectedClass class methods
						reject: [ :meth | meth isFromTrait ]).

			methodsLabel visibility: BlVisibility visible.
			protocolLabel visibility: BlVisibility visible ]
		ifFalse: [ methodProtocolsList initializeWithProtocols: Array empty.
			self updateMethodListWith: #() and: #().

			protocolLabel visibility: BlVisibility hidden.
			methodProtocolsList visibility: BlVisibility hidden.
			methodsLabel visibility: BlVisibility hidden ]
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSelectedPackageAndTag [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedPackage
		ifTrue: [ navigationModel hasSelectedTag
				ifTrue: [ self
						selectPackage: navigationModel selectedPackage
						tag: navigationModel selectedTag ]
				ifFalse: [ self selectPackage: navigationModel selectedPackage ] ]
]
