Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #BlElement,
	#instVars : [
		'packagesList',
		'classesList',
		'navigationModel'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'api - packages' }
GtCoderNavigationPackagesTagsClassesElement >> expandPackage: anRPackage [
	packagesList viewModel root
		allChildrenNodesBreadthFirstDo: [ :eachTreeNode |
			eachTreeNode value = anRPackage
				ifTrue: [ eachTreeNode expand ] ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initialize [
	super initialize.
	
	self layout: (BlGridLayout horizontal columnCount: 2).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	
	packagesList := GtCoderNavigationPackagesListElement new.
	classesList := GtCoderNavigationClassesHierarchyListElement new.
	
	self addChildren: {
		BrLabel new
			look: (BrGlamorousLabelLook new fontSize: 14; foreground: Color gray);
			text: 'Packages'.
			
		BrLabel new
			look: (BrGlamorousLabelLook new fontSize: 14; foreground: Color gray);
			text: 'Classes'.
			
		BlElement new
			height: 1;
			margin: (BlInsets top: 5 bottom: 5);
			constraintsDo: [ :c |
				c horizontal matchParent.
				c grid horizontal span: 2 ];
			background: BrGlamorousColors neutralBackgroundColor.
	
		packagesList.
		classesList
	}
]

{ #category : #accessing }
GtCoderNavigationPackagesTagsClassesElement >> navigationModel [
	<return: #GtCoderNavigationPackagesTagsClassesModel>

	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationPackagesTagsClassesElement >> navigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	
	packagesList initializeWithPackages: navigationModel packagesToShow.
	classesList initializeWithClasses: navigationModel classesToShow.
	
	navigationModel hasSelectedPackage
		ifTrue: [ navigationModel hasSelectedTag
			ifTrue: [
				self expandPackage: navigationModel selectedPackage.
				packagesList viewModel
					indexOf: navigationModel selectedTag
					do: [ :anIndex | packagesList selectOne: anIndex ] ]
			ifFalse: [ packagesList viewModel
					indexOf: navigationModel selectedPackage
					do: [ :anIndex | packagesList selectOne: anIndex ] ] ].

	navigationModel selectedClassDo: [ :aClass |
		classesList viewModel
			indexOfSuchThat: [ :each | each rootClass = aClass ]
			do: [ :anIndex | classesList selectOne: anIndex ] ].
	
	packagesList
		when: BrSelectionChanged
		do: [ :anEvent |
			anEvent currentTarget selectedIndices
				ifNotEmpty: [ :theIndices |
					| anIndex aSelectedItem |
					anIndex := theIndices first.
					(anIndex between: 1 and: anEvent currentTarget items size)
						ifTrue: [
							aSelectedItem := (anEvent currentTarget viewModel itemAt: anIndex) value.
							(aSelectedItem isKindOf: RPackage)
								ifTrue: [ self navigationModel selectPackage: aSelectedItem ]
								ifFalse: [ self navigationModel selectTag: aSelectedItem ] ] ] ].
				
	classesList
		when: BrSelectionChanged
		do: [ :anEvent |
			anEvent currentTarget selectedIndices
				ifNotEmpty: [ :theIndices |
					| anIndex aSelectedItem |
					anIndex := theIndices first.
					(anIndex between: 1 and: anEvent currentTarget items size)
						ifTrue: [
							aSelectedItem := (anEvent currentTarget viewModel itemAt: anIndex) value rootClass.
							self navigationModel selectClass: aSelectedItem  ] ] ].
	
	navigationModel when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel when: GtCoderNavigationTagSelected send: #onTagSelected: to: self.
	navigationModel when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onClassSelected: anAnnouncement [
	classesList viewModel
		indexOfSuchThat: [ :each | each rootClass = anAnnouncement theClass ]
		do: [ :anIndex | classesList selectOne: anIndex ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onPackageSelected: anAnnouncer [

	packagesList viewModel
		indexOf: anAnnouncer package
		do: [ :anIndex | packagesList selectOne: anIndex ].
		
	classesList initializeWithClasses: navigationModel classesToShow
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onTagSelected: anAnnouncer [
	self expandPackage: anAnnouncer package.

	packagesList viewModel
		indexOf: anAnnouncer tag
		do: [ :anIndex | packagesList selectOne: anIndex ].
		
	classesList initializeWithClasses: navigationModel classesToShow
]
