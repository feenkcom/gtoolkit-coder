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
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self 
			updateClass: anAnnouncement theClass
			inPackage: anAnnouncement package
			tag: anAnnouncement tag ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierachyElement >> onClassRenamed: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self 
			renameClass: anAnnouncement theClass 
			oldName: anAnnouncement oldName 
			newName: anAnnouncement newName
			inPackage: anAnnouncement package
			tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onClassSelected: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self updateClassListsWith: anAnnouncement theClass.
		self selectClass: anAnnouncement theClass ].
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackageSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [ 
		self emptyClassList.
		self deselectClasses. ]
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackageTagSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self emptyClassList.
		self deselectClasses. ].
]

{ #category : #'event handling' }
GtCoderNavigationClassHierachyElement >> onPackagesSelected: anAnnouncer [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [ 
		self emptyClassList.
		self deselectClasses. ]
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
	navigationModel when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self.
	navigationModel when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self.
	navigationModel when: GtCoderNavigationPackageTagSelected send: #onPackageTagSelected: to: self.
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
