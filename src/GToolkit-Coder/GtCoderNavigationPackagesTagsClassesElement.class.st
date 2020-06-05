Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationElement,
	#instVars : [
		'packagesList',
		'classesList',
		'classesLabel'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> addPackage: aPackage [
	| aSelectedPackage |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackage := aNode value ].

	self updatePackageLists.
	aSelectedPackage ifNotNil: [
		self selectPackage: aSelectedPackage ].
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> addPackage: aPackage tag: aPackageTag [
	| aSelectedPackage |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackage := aNode value ].

	self updatePackageLists.
	aSelectedPackage ifNotNil: [
		self selectPackage: aSelectedPackage ].
]

{ #category : #'api - classes' }
GtCoderNavigationPackagesTagsClassesElement >> deselectClasses [
	classesList deselectAll
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> deselectPackages [
	packagesList deselectAll
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> expandPackage: anRPackage [
	packagesList viewModel root
		allChildrenNodesBreadthFirstDo: [ :eachTreeNode |
			eachTreeNode value = anRPackage
				ifTrue: [ eachTreeNode expand ] ]
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> hideClassList [
	classesList visibility: BlVisibility gone.
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
	packagesList := GtCoderNavigationPackagesTreeElement new.
	classesList := GtCoderNavigationClassesHierarchyTreeElement new.
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeElement [
	self addChildren: {
		BrLabel new
			look: (BrGlamorousLabelLook new fontSize: 12; foreground: Color gray);
			text: 'Packages'.
			
		classesLabel := BrLabel new
			look: (BrGlamorousLabelLook new fontSize: 12; foreground: Color gray);
			text: 'Classes'.
	
		packagesList.
		classesList
	}
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeLayout [
	self layout: (BlGridLayout horizontal columnCount: 2; cellSpacing: 5).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onClassListSelectionChanged [
	| anIndex aSelectedItem theIndices |
	supressListChanges ifTrue: [ ^ self ].
	theIndices := classesList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: classesList viewModel itemCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (classesList viewModel itemAt: anIndex) value rootClass.
	self navigationModel selectClass: aSelectedItem
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onClassSelected: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self 
			selectClass: anAnnouncement theClass
			inPackage: anAnnouncement package 
			tag: anAnnouncement tag ].
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
GtCoderNavigationPackagesTagsClassesElement >> onTagSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self 
			selectPackage: anAnnouncer package 
			tag: anAnnouncer tag.
		self deselectClasses. ].
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> removePackage: aPackage [
	| aSelectedPackage anIndex |

	anIndex := packagesList viewModel indexOf: aPackage.
	anIndex > 0 ifFalse: [ ^ self ].
		
	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackage := aNode value ].

	self updatePackageLists.
	aSelectedPackage ifNotNil: [
		aSelectedPackage = aPackage 
			ifTrue: [ 
				self deselectPackages.
				self hideClassList. ]
			ifFalse: [ self selectPackage: aSelectedPackage ] ].
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> renamePackage: aPackage oldName: anOldName newName: aNewName [
	| aSelectedPackage |

	packagesList selectedNodeDo: [ :aNode | 
		aSelectedPackage := aNode value ].

	self updatePackageLists.
	aSelectedPackage ifNotNil: [
		self selectPackage: aSelectedPackage ].
]

{ #category : #'api - classes' }
GtCoderNavigationPackagesTagsClassesElement >> selectClass: aClass [
	classesList viewModel
		indexOfSuchThat: [ :each | each rootClass = aClass ]
		do: [ :anIndex | classesList 
			selectOne: anIndex;
			scrollTo: anIndex ]
]

{ #category : #'api - classes' }
GtCoderNavigationPackagesTagsClassesElement >> selectClass: aClass inPackage: aPackage tag: aPackageTag [
	| anExistingIndex |
	
	anExistingIndex := classesList viewModel indexOfSuchThat: [ :each | each rootClass = aClass ].
	anExistingIndex isZero ifTrue: [ 
		self selectPackage: aPackage tag: aPackageTag ].
	
	self selectClass: aClass.
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> selectPackage: aPackage [

	packagesList viewModel
		indexOf: aPackage
		do: [ :anIndex | packagesList 
			selectOne: anIndex;
			scrollTo: anIndex ].

	self updateClassLists.
	self hideOrShowClassList.
]

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> selectPackage: aPackage tag: aPackageTag [
	self expandPackage: aPackage.

	packagesList viewModel
		indexOf: aPackageTag
		do: [ :anIndex | packagesList 
			selectOne: anIndex;
			scrollTo: anIndex ].
		
	self updateClassLists.
	self hideOrShowClassList.
]

{ #category : #'showing / hiding' }
GtCoderNavigationPackagesTagsClassesElement >> showClassList [
	classesList visibility: BlVisibility visible.
	classesLabel visibility: BlVisibility visible.
	self layout columnCount: 2.
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToClassList [
	classesList
		when: BrSelectionChanged
		do: [ :anEvent | self onClassListSelectionChanged ].
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToPackageList.
	self subscribeToClassList.

]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToNavigationModel [
	super subscribeToNavigationModel.
	navigationModel when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self.
	navigationModel when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel when: GtCoderNavigationTagSelected send: #onTagSelected: to: self.
	navigationModel when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
	navigationModel when: GtCoderNavigationPackageRegistered send: #onPackageRegistered: to: self.
	navigationModel when: GtCoderNavigationPackageUnregistered send: #onPackageUnregistered: to: self.
	navigationModel when: GtCoderNavigationPackageRenamed send: #onPackageRenamed: to: self.
	navigationModel when: GtCoderNavigationPackageTagAdded send: #onPackageTagAdded: to: self.
]

{ #category : #subscriptions }
GtCoderNavigationPackagesTagsClassesElement >> subscribeToPackageList [
	packagesList
		when: BrSelectionChanged
		do: [ :anEvent | self onPackageListSelectionChanged ].
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateClassLists [
	classesList initializeWithClasses: navigationModel classesToShow.
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
	packagesList initializeWithPackages: navigationModel packagesToShow.
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSelectedClass [
	navigationModel selectedClassDo: [ :aClass |
		classesList viewModel
			indexOfSuchThat: [ :each | each rootClass = aClass ]
			do: [ :anIndex | classesList
				selectOne: anIndex;
				scrollTo: (anIndex - 5 max: 1) ] ].
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSelectedPackageAndTag [
	navigationModel hasSelectedPackage
		ifTrue: [ navigationModel hasSelectedTag
			ifTrue: [
				self expandPackage: navigationModel selectedPackage.
				packagesList viewModel
					indexOf: navigationModel selectedTag
					do: [ :anIndex | packagesList
						selectOne: anIndex;
						scrollTo: (anIndex - 5 max: 1) ] ]
			ifFalse: [ packagesList viewModel
					indexOf: navigationModel selectedPackage
					do: [ :anIndex | packagesList
						selectOne: anIndex;
						scrollTo: (anIndex - 5 max: 1) ] ] ].
]
