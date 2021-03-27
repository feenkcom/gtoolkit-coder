Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationElement,
	#instVars : [
		'packagesList',
		'classesLabel',
		'methodProtocolsList',
		'classAndMethodProtocolList',
		'protocolLabel',
		'coderFilterChangesSubscription'
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
	classAndMethodProtocolList visibility: BlVisibility gone.
	classesLabel visibility: BlVisibility gone.
	self layout columnCount: 1.
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
	packagesList := GtCoderNavigationPackagesTreeElement new.
	
	methodProtocolsList := GtCoderNavigationMethodProtocolListElement new 
		matchParent.
	
	classAndMethodProtocolList := BrVerticalPane new
		matchParent;
		addChild: classesList;
		addChild: (protocolLabel := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new fontSize: 12; foreground: Color gray);
			text: 'Categories');
		addChild: methodProtocolsList.
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeElement [
	super initializeElement.
	self addChildren: {
		BrLabel new
			aptitude: (BrGlamorousLabelAptitude new fontSize: 12; foreground: Color gray);
			text: 'Packages'.
			
		classesLabel := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new fontSize: 12; foreground: Color gray);
			text: 'Classes'.
	
		packagesList.
		classAndMethodProtocolList.
	}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeLayout [
	super initializeLayout.
	self layout: (BlGridLayout horizontal columnCount: 2; cellSpacing: 5).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onMethodsCoderFiltersChanged: aGtCodersFiltersChanged [
	aGtCodersFiltersChanged source = self ifTrue: [ ^ self ].
	
	methodProtocolsList selectedItemDo: [ :aSelectedItem | 
		| aCategoryFilter |
		aCategoryFilter := GtSearchMethodCategoryFilter forCategory: aSelectedItem name.
		
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
	(anIndex between: 1 and: packagesList viewModel itemCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (packagesList viewModel itemAt: anIndex) value.
	(aSelectedItem isKindOf: RPackage)
		ifTrue: [ self navigationModel selectPackage: aSelectedItem ]
		ifFalse: [ self navigationModel selectTag: aSelectedItem ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageRegistered: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self addPackage: anAnnouncement package ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageRenamed: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self 
			renamePackage: anAnnouncement package 
			oldName: anAnnouncement oldName 
			newName: anAnnouncement newName ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self selectPackage: anAnnouncer package.
		self deselectClasses. ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagAdded: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self addPackage: anAnnouncement package tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagRemoved: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self removePackage: anAnnouncement package tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageTagSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self 
			selectPackage: anAnnouncer package 
			tag: anAnnouncer tag.
		self deselectClasses. ].
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageUnregistered: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self removePackage: anAnnouncement package ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackagesSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self deselectPackages.
		self deselectClasses. ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onProtocolListSelectionChanged [
	| anIndex aSelectedItem theIndices |
	supressListChanges ifTrue: [ ^ self ].
	theIndices := methodProtocolsList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: methodProtocolsList viewModel itemCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (methodProtocolsList viewModel itemAt: anIndex) value.
	self navigationModel selectMethodProtocol: aSelectedItem source: self.
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
	(self hasPackageTagsIn: aPackage)
		ifFalse: [ ^ self selectPackage: aPackage ].
	self expandPackage: aPackage.
	aPreviousIndex := packagesList selectedIndice.
	packagesList viewModel
		indexOf: aPackageTag
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
	self layout columnCount: 2.
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
	self hasNavigationModel ifFalse: [ ^ self ].
	super subscribeToNavigationModel.
	navigationModel when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self.
	navigationModel when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel when: GtCoderNavigationPackageTagSelected send: #onPackageTagSelected: to: self.
	navigationModel when: GtCoderNavigationPackageRegistered send: #onPackageRegistered: to: self.
	navigationModel when: GtCoderNavigationPackageUnregistered send: #onPackageUnregistered: to: self.
	navigationModel when: GtCoderNavigationPackageRenamed send: #onPackageRenamed: to: self.
	navigationModel when: GtCoderNavigationPackageTagAdded send: #onPackageTagAdded: to: self.
	navigationModel when: GtCoderNavigationPackageTagRemoved send: #onPackageTagRemoved: to: self.
	navigationModel when: GtCodersFiltersChanged send: #onMethodsCoderFiltersChanged: to: self.
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToPackageList [
	packagesList
		when: BrSelectionChanged
		do: [ :anEvent | self onPackageListSelectionChanged ].
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

	navigationModel hasSelectedClass
		ifTrue: [ 
			| methodProtocols |
			methodProtocols := navigationModel selectedClass organization protocols.
			methodProtocolsList initializeWithProtocols: methodProtocols.
			protocolLabel visibility: BlVisibility visible.
			methodProtocolsList visibility: BlVisibility visible. ]
		ifFalse: [ 
			methodProtocolsList initializeWithProtocols: Array empty.
			protocolLabel visibility: BlVisibility gone.
			methodProtocolsList visibility: BlVisibility gone. ]
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateContent [
	self updatePackageAndClassLists.
	self updateSelectedPackageAndTag.
	self updateSelectedClass.
	self hideOrShowClassList
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
GtCoderNavigationPackagesTagsClassesElement >> updateSelectedPackageAndTag [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedPackage
		ifTrue: [ navigationModel hasSelectedTag
			ifTrue: [
				self 
					selectPackage: navigationModel selectedPackage 
					tag: navigationModel selectedTag ] ]
			ifFalse: [ 
				self selectPackage: navigationModel selectedPackage ].
]
