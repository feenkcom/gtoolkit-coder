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
	packagesList
		when: BrSelectionChanged
		do: [ :anEvent |
			anEvent currentTarget selectedIndices
				ifNotEmpty: [ :theIndices |
					| aSelectedItem |
					aSelectedItem := (anEvent currentTarget viewModel itemAt: theIndices first) value.
					(aSelectedItem isKindOf: RPackage)
						ifTrue: [ self navigationModel selectPackage: aSelectedItem ]
						ifFalse: [ self navigationModel selectTag: aSelectedItem ] ] ].
	
	classesList initializeWithClasses: navigationModel classesToShow.
	navigationModel when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel when: GtCoderNavigationTagSelected send: #onTagSelected: to: self.
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
