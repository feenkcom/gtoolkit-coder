Class {
	#name : #GtCoderNavigationClassHierachyElement,
	#superclass : #GtCoderNavigationElement,
	#instVars : [
		'classesList'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'api - classes' }
GtCoderNavigationClassHierachyElement >> deselectClasses [
	classesList deselectAll
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> emptyClassList [
	classesList initializeWithClasses: #()
]

{ #category : #initialization }
GtCoderNavigationClassHierachyElement >> initializeContent [
	classesList := GtCoderNavigationClassesHierarchyTreeElement new.
]

{ #category : #initialization }
GtCoderNavigationClassHierachyElement >> initializeElement [
	self addChild: classesList
]

{ #category : #initialization }
GtCoderNavigationClassHierachyElement >> initializeLayout [
	self layout: BlLinearLayout vertical.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
]

{ #category : #initialization }
GtCoderNavigationClassHierachyElement >> listItemStencil: aStencilBuilder [
	classesList stencil: aStencilBuilder
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onClassListSelectionChanged [
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
GtCoderNavigationClassHierachyElement >> onClassSelected: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self updateClassListsWith: anAnnouncement theClass.
		self selectClass: anAnnouncement theClass ].
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onNavigationModelChanged [
	self updateClassLists.
	self updateSelectedClass.
	self subscribeToClassList.
	self subscribeToNavigationModel."
	self hideOrShowClassList."
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackageSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [ 
		self emptyClassList.
		self deselectClasses. ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackagesSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [ 
		self emptyClassList.
		self deselectClasses. ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onTagSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self emptyClassList.
		self deselectClasses. ].
]

{ #category : #'api - classes' }
GtCoderNavigationClassHierachyElement >> selectClass: aClass [

	classesList viewModel
		indexOfSuchThat: [ :each | each rootClass = aClass ]
		do: [ :anIndex | classesList 
			selectOne: anIndex;
			scrollTo: anIndex ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> subscribeToClassList [
	classesList
		when: BrSelectionChanged
		do: [ :anEvent | self onClassListSelectionChanged ].
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> subscribeToNavigationModel [
	navigationModel when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self.
	navigationModel when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel when: GtCoderNavigationTagSelected send: #onTagSelected: to: self.
	navigationModel when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> updateClassLists [
	| theClasses |
	theClasses := navigationModel classesToShow.
	theClasses size = 1 
		ifTrue: [ self updateClassListsWith: theClasses anyOne ]
		ifFalse: [ self emptyClassList ].
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> updateClassListsWith: aClass [
	classesList initializeWithHierachyForClass: aClass
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> updateSelectedClass [
	navigationModel selectedClassDo: [ :aClass |
		classesList viewModel
			indexOfSuchThat: [ :each | each rootClass = aClass ]
			do: [ :anIndex | classesList
				selectOne: anIndex;
				scrollTo: (anIndex - 5 max: 1) ] ].
]
