Class {
	#name : #GtCoderNavigationElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
		'supressNavigationChanges',
		'supressListChanges',
		'classesList'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #asserting }
GtCoderNavigationElement >> assertNavigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self 
		assert: [ aGtCoderNavigationPackagesTagsClassesModel isNotNil ] 
		description: [ 'Navigation model must be non-nil' ].
]

{ #category : #'api - class selections' }
GtCoderNavigationElement >> deselectClasses [
	classesList deselectAll
]

{ #category : #testing }
GtCoderNavigationElement >> hasNavigationModel [
	^ self navigationModel isNotNil and: [
		self navigationModel isNavigationModel ]
]

{ #category : #initialization }
GtCoderNavigationElement >> initialize [
	super initialize.
	supressListChanges := false.
	supressNavigationChanges := false.
	self initializeLayout.
	self initializeContent.
	self initializeElement.
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeContent [
	classesList := GtCoderNavigationClassesHierarchyTreeElement new.
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeElement [
	"subclasses may initialize element"
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeLayout [
	"subclasses may define its layout"
]

{ #category : #accessing }
GtCoderNavigationElement >> navigationModel [
	<return: #GtCoderNavigationPackagesTagsClassesModel>

	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationElement >> navigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self assertNavigationModel: aGtCoderNavigationPackagesTagsClassesModel.
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	self onNavigationModelChanged.
]

{ #category : #'hooks - children' }
GtCoderNavigationElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self updateContent.
	self subscribeToNavigationModel.
	self subscribeToContent.
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassModified: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [
		self 
			updateClass: anAnnouncement theClass
			inPackage: anAnnouncement package
			tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassRenamed: anAnnouncement [
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
GtCoderNavigationElement >> onClassSelected: anAnnouncement [
	supressNavigationChanges ifTrue: [ ^ self ].
	self suppressListChangeEventsDuring: [  
		self 
			selectClass: anAnnouncement theClass
			inPackage: anAnnouncement package 
			tag: anAnnouncement tag ].
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
	self isAttachedToSceneGraph ifFalse: [ ^ self ].
	self subscribeToNavigationModel.
	self updateContent.
]

{ #category : #'hooks - children' }
GtCoderNavigationElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	self unsuscribeFromContent.
	self unsubscribeFromNavigationModel.
]

{ #category : #'api - class updates' }
GtCoderNavigationElement >> renameClass: aClass oldName: anOldName newName: aNewName inPackage: aPackage tag: aTag [
	
	classesList viewModel 
		indexOfSuchThat: [ :aTree | 
			aTree rootClass = aClass ] 
		do: [ :aTree | 
			self updateClassLists.
			self updateSelectedClass ].
]

{ #category : #'private - selection' }
GtCoderNavigationElement >> scrollIndexFrom: aNodeIndex [
	<return: #Number>
	"TODO: does not work if an index is at a bottom: aNodeIndex - 5 max: 1"
	^ aNodeIndex 
]

{ #category : #'private - selection' }
GtCoderNavigationElement >> scrollIndexFromPrevious: aPreviousIndex current: aNewIndex max: aNumberOfItems [
	<return: #Number>
	^ (aPreviousIndex isZero or: [ aPreviousIndex >= aNewIndex ])
		ifTrue: [ aNewIndex - 5 max: 1 ]
		ifFalse: [ aNewIndex + 5 min: aNumberOfItems ].
]

{ #category : #'api - class selections' }
GtCoderNavigationElement >> selectClass: aClass [
	| aPreviousIndex |
	aPreviousIndex := classesList selectedIndice.
	classesList viewModel
		indexOfSuchThat: [ :each | each rootClass = aClass ]
		do: [ :aNewIndex | 
			classesList
				selectOne: aNewIndex;
				scrollToIndex:
					(self
						scrollIndexFromPrevious: aPreviousIndex
						current: aNewIndex
						max: classesList viewModel itemCount) ]
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToContent [
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToNavigationModel [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
	navigationModel when: GtCoderNavigationClassRenamed send: #onClassRenamed: to: self.
	navigationModel when: GtCoderNavigationClassModified send: #onClassModified: to: self.
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressListChangeEventsDuring: aBlock [
	| anOldValue |
	anOldValue := supressListChanges.
	supressListChanges := true.
	aBlock ensure: [ supressListChanges := anOldValue ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressNavigationChangeEventsDuring: aBlock [
	| anOldValue |
	anOldValue := supressNavigationChanges.
	supressNavigationChanges := true.
	aBlock ensure: [ supressNavigationChanges := anOldValue ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> unsubscribeFromNavigationModel [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> unsuscribeFromContent [
]

{ #category : #'api - class updates' }
GtCoderNavigationElement >> updateClass: aClass inPackage: aPackage tag: aTag [
	
	classesList viewModel 
		indexOfSuchThat: [ :aTree | 
			aTree rootClass = aClass ] 
		do: [ :aTree | 
			self updateClassLists.
			self updateSelectedClass ].
]

{ #category : #'updating lists' }
GtCoderNavigationElement >> updateClassLists [
	"Update class list"
]

{ #category : #updating }
GtCoderNavigationElement >> updateContent [
]

{ #category : #'updating lists' }
GtCoderNavigationElement >> updateSelectedClass [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel selectedClassDo: [ :aClass |
		self selectClass: aClass ].
]
