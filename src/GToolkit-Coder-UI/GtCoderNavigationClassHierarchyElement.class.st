Class {
	#name : #GtCoderNavigationClassHierarchyElement,
	#superclass : #GtCoderNavigationElement,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtCoderNavigationClassHierarchyElement >> initializeElement [
	super initializeElement.
	self addChild: classesList
]

{ #category : #initialization }
GtCoderNavigationClassHierarchyElement >> initializeLayout [
	super initializeLayout.
	self layout: BlLinearLayout vertical.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onClassDeselected: aGtCoderNavigationClassDeselected [ 
	self deselectClass: aGtCoderNavigationClassDeselected theClass
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> onClassModified: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				updateClass: anAnnouncement theClass
				inPackage: anAnnouncement package
				tag: anAnnouncement tag ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> onClassRemoved: anAnnouncement [
	| newSelection |
	newSelection := anAnnouncement theClass superclass.
	self
		inUIProcessDo: [ self updateClassListsWith: newSelection.
			self selectClass: newSelection ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> onClassRenamed: anAnnouncement [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self
						renameClass: anAnnouncement theClass
						oldName: anAnnouncement oldName
						newName: anAnnouncement newName
						inPackage: anAnnouncement package
						tag: anAnnouncement tag ] ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onClassSelected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self selectClass: anAnnouncement theClass ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onPackageSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self emptyClassList.
					self deselectClasses ] ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onPackageTagSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self emptyClassList.
					self deselectClasses ] ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onPackagesSelected: anAnnouncer [
	self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self emptyClassList.
					self deselectClasses ] ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToClassList.
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> subscribeToNavigationModel [
	self hasNavigationModel ifFalse: [ ^ self ].
	super subscribeToNavigationModel.
	navigationModel weak when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self.
	navigationModel weak when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel weak when: GtCoderNavigationPackageTagSelected send: #onPackageTagSelected: to: self.
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierarchyElement >> updateClassList [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedClass 
		ifTrue: [ self updateClassListsWith: navigationModel selectedClass ]
		ifFalse: [ self emptyClassList ].
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierarchyElement >> updateClassListsWith: aClass [
	classesList initializeWithHierachyForClass: aClass.
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierarchyElement >> updateContent [
	self updateClassList.
	self updateSelectedClass
]
