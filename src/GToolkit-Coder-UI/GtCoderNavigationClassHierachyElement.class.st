Class {
	#name : #GtCoderNavigationClassHierachyElement,
	#superclass : #GtCoderNavigationElement,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtCoderNavigationClassHierachyElement >> initializeElement [
	super initializeElement.
	self addChild: classesList
]

{ #category : #initialization }
GtCoderNavigationClassHierachyElement >> initializeLayout [
	super initializeLayout.
	self layout: BlLinearLayout vertical.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> onClassModified: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				updateClass: anAnnouncement theClass
				inPackage: anAnnouncement package
				tag: anAnnouncement tag ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> onClassRenamed: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				renameClass: anAnnouncement theClass
				oldName: anAnnouncement oldName
				newName: anAnnouncement newName
				inPackage: anAnnouncement package
				tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onClassSelected: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self updateClassListsWith: anAnnouncement theClass.
			self selectClass: anAnnouncement theClass ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackageSelected: anAnnouncer [
	self
		suppressListChangeEventsDuring: [ self emptyClassList.
			self deselectClasses ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackageTagSelected: anAnnouncer [
	self
		suppressListChangeEventsDuring: [ self emptyClassList.
			self deselectClasses ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackagesSelected: anAnnouncer [
	self
		suppressListChangeEventsDuring: [ self emptyClassList.
			self deselectClasses ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> subscribeToContent [
	super subscribeToContent.
	self subscribeToClassList.
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> subscribeToNavigationModel [
	self hasNavigationModel ifFalse: [ ^ self ].
	super subscribeToNavigationModel.
	navigationModel weak when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self.
	navigationModel weak when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel weak when: GtCoderNavigationPackageTagSelected send: #onPackageTagSelected: to: self.
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> updateClassLists [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedClass 
		ifTrue: [ self updateClassListsWith: navigationModel selectedClass ]
		ifFalse: [ self emptyClassList ].
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> updateClassListsWith: aClass [
	classesList initializeWithHierachyForClass: aClass.
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierachyElement >> updateContent [
	self updateClassLists.
	self updateSelectedClass
]
