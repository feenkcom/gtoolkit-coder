Class {
	#name : #GtCoderNavigationBasicPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationElement,
	#instVars : [
		'packagesList',
		'classesLabel'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'api - package updates' }
GtCoderNavigationBasicPackagesTagsClassesElement >> addPackage: aPackage [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #'api - package updates' }
GtCoderNavigationBasicPackagesTagsClassesElement >> addPackage: aPackage tag: aPackageTag [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> deselectPackages [
	packagesList deselectAll
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> expandPackage: aRPackage [
	packagesList viewModel root
		allChildrenNodesBreadthFirstDo: [ :eachTreeNode |
			eachTreeNode value = aRPackage
				ifTrue: [ eachTreeNode expand ] ]
]

{ #category : #'private - testing' }
GtCoderNavigationBasicPackagesTagsClassesElement >> hasPackageTagsIn: aRPackage [
	<return: #Boolean>
	| noTags noExtensions |
	noTags := (aRPackage tags size = 1 and: [ aRPackage tags anyOne name = aRPackage name ]).
	noExtensions := aRPackage extendedClasses isEmpty.
	^ noTags not or: [ noExtensions not ]
]

{ #category : #initialization }
GtCoderNavigationBasicPackagesTagsClassesElement >> headerLabel [
	| label |
	label := BrLabel new.
	label
		aptitude: (BrGlamorousLabelAptitude new
				fontSize: 12;
				foreground: Color gray).
	^ label
]

{ #category : #'showing / hiding' }
GtCoderNavigationBasicPackagesTagsClassesElement >> hideClassList [
	classesLabel visibility: BlVisibility hidden.
]

{ #category : #'showing / hiding' }
GtCoderNavigationBasicPackagesTagsClassesElement >> hideOrShowClassList [
	classesList maxSelectionIndex isZero 
		ifTrue: [ self hideClassList ] 
		ifFalse: [ self showClassList ]
]

{ #category : #initialization }
GtCoderNavigationBasicPackagesTagsClassesElement >> initializeContent [
	super initializeContent.
	packagesList := GtCoderPackagesTreeElement new
			padding: (BlInsets right: 10).
]

{ #category : #initialization }
GtCoderNavigationBasicPackagesTagsClassesElement >> initializeElement [
	| pane1 pane2 |
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
	self addChildren: { pane1. pane2 }
]

{ #category : #initialization }
GtCoderNavigationBasicPackagesTagsClassesElement >> initializeLayout [
	super initializeLayout.
	self layout: BlLinearLayout new beHorizontal.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onClassDeselected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self deselectClass: anAnnouncement theClass ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onClassRemoved: anAnnouncement [
	| aPackageOrTag |
	self
		inUIProcessDo: [ aPackageOrTag := self selectedPackageOrTag.
			packagesList deselectAll.
			self selectPackage: aPackageOrTag ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onClassSelected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self selectClasses: anAnnouncement selectedClasses ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageListSelectionChanged [
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
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageRegistered: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self addPackage: anAnnouncement package ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageRenamed: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				renamePackage: anAnnouncement package
				oldName: anAnnouncement oldName
				newName: anAnnouncement newName ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageSelected: anAnnouncer [
	self inUIProcessDo: [ self suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package ] ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageTagAdded: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self addPackage: anAnnouncement package tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageTagRemoved: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self removePackage: anAnnouncement package tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageTagRenamed: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				renamePackageTag: anAnnouncement package
				oldName: anAnnouncement oldName
				newName: anAnnouncement newName ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageTagSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self selectPackage: anAnnouncer package tag: anAnnouncer tag.
					"self deselectClasses" ] ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackageUnregistered: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self removePackage: anAnnouncement package ]
]

{ #category : #'event handling - selection' }
GtCoderNavigationBasicPackagesTagsClassesElement >> onPackagesSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self deselectPackages.
					self deselectClasses ] ]
]

{ #category : #'api - package updates' }
GtCoderNavigationBasicPackagesTagsClassesElement >> removePackage: aPackage [
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
GtCoderNavigationBasicPackagesTagsClassesElement >> removePackage: aPackage tag: aPackageTagName [
	| aSelectedPackageOrTag anIndex |
	anIndex := packagesList viewModel indexOf: aPackage.
	anIndex > 0 ifFalse: [ ^ self ].
	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].
	self updatePackageLists.
	self reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfTagNamed: aPackageTagName.
]

{ #category : #'api - package updates' }
GtCoderNavigationBasicPackagesTagsClassesElement >> renamePackage: aPackage oldName: anOldName newName: aNewName [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #'api - package updates' }
GtCoderNavigationBasicPackagesTagsClassesElement >> renamePackageTag: aPackageTag oldName: anOldName newName: aNewName [
	| aSelectedPackageOrTag |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackageOrTag := aNode value ].

	self updatePackageLists.
	aSelectedPackageOrTag ifNotNil: [
		self selectPackageOrTag: aSelectedPackageOrTag ].
]

{ #category : #'api - package reselections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfPackageNamed: aRemovedPackageOrTagName [
	aSelectedPackageOrTag ifNotNil: [ 
		self deselectPackages.
		aSelectedPackageOrTag name = aRemovedPackageOrTagName
			ifTrue: [ 
				self hideClassList ]
			ifFalse: [ 
				self selectPackageOrTag: aSelectedPackageOrTag ] ]
]

{ #category : #'api - package reselections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> reselectPackageOrTag: aSelectedPackageOrTag afterRemovalOfTagNamed: aRemovedTagName [
	aSelectedPackageOrTag
		ifNotNil: [ self deselectPackages.
			(aSelectedPackageOrTag name sameContentAs: aRemovedTagName)
				ifTrue: [ self expandPackage: aSelectedPackageOrTag package.
					self hideClassList ]
				ifFalse: [ self selectPackageOrTag: aSelectedPackageOrTag ] ]
]

{ #category : #'api - class selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectClass: aClass inPackage: aPackage tag: aPackageTag [
	self selectedPackage ~= aPackage
		ifTrue: [ self selectPackage: aPackage tag: aPackageTag ].

	self selectClass: aClass.
	self updateProtocolList.
	self updateSlotList
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectPackage: aPackage [
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
GtCoderNavigationBasicPackagesTagsClassesElement >> selectPackage: aPackage tag: aPackageTag [
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
GtCoderNavigationBasicPackagesTagsClassesElement >> selectPackageOrTag: aPackageOrTag [
	(aPackageOrTag isKindOf: RPackage)
		ifTrue: [ self selectPackage: aPackageOrTag ] 
		ifFalse: [ self selectPackage: aPackageOrTag package tag: aPackageOrTag ]
]

{ #category : #'api - class selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectedClass [
	<return: #Class or: nil>
	^ classesList selectedClass
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectedPackage [
	<return: #RPackage or: nil>
	^ packagesList selectedPackage
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectedPackageNodeDo: aBlock [
	^ packagesList selectedPackageNodeDo: aBlock
]

{ #category : #'api - package updates' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectedPackageOrTag [
	| aSelectedPackageOrTag |
	packagesList selectedNodeDo: [ :aNode | aSelectedPackageOrTag := aNode value ].
	^ aSelectedPackageOrTag
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectedPackageTag [
	<return: #RPackageTag or: nil>
	^ packagesList selectedPackageTag
]

{ #category : #'api - package selections' }
GtCoderNavigationBasicPackagesTagsClassesElement >> selectedPackageTagNodeDo: aBlock [
	^ packagesList selectedPackageTagNodeDo: aBlock
]

{ #category : #'showing / hiding' }
GtCoderNavigationBasicPackagesTagsClassesElement >> showClassList [
	classesList visibility: BlVisibility visible.
	classesLabel visibility: BlVisibility visible
]

{ #category : #subscriptions }
GtCoderNavigationBasicPackagesTagsClassesElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToPackageList.
	self subscribeToClassList.
]

{ #category : #subscriptions }
GtCoderNavigationBasicPackagesTagsClassesElement >> subscribeToNavigationModel [
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
			"Announcements when we need to update items in the lists"
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
GtCoderNavigationBasicPackagesTagsClassesElement >> subscribeToPackageList [
	packagesList
		when: BrSelectionChanged
		do: [ :anEvent | self onPackageListSelectionChanged ]
]

{ #category : #'updating lists' }
GtCoderNavigationBasicPackagesTagsClassesElement >> updateClassList [
	self hasNavigationModel
		ifFalse: [ ^ self ].
	
	classesList initializeWithClasses: navigationModel classesToShow.
	
	navigationModel selectedClasses
		ifNotNil: [ :aCollectionOfClasses | self selectClasses: aCollectionOfClasses ]
]

{ #category : #'updating lists' }
GtCoderNavigationBasicPackagesTagsClassesElement >> updateContent [
	self updatePackageLists.
	self updateClassList.
]

{ #category : #'updating lists' }
GtCoderNavigationBasicPackagesTagsClassesElement >> updatePackageLists [
	self hasNavigationModel
		ifFalse: [ ^ self ].
	
	packagesList initializeWithPackages: navigationModel packagesToShow.

	navigationModel selectedPackage
		ifNotNil: [ :aPackage | self selectPackage: aPackage tag: navigationModel selectedTag ]
]
