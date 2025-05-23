Class {
	#name : #GtCoderNavigationElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
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

{ #category : #'private-accessing' }
GtCoderNavigationElement >> classesList [
	^classesList
]

{ #category : #'api - class selections' }
GtCoderNavigationElement >> deselectClass: aClass [
	classesList deselectAll
]

{ #category : #'api - class selections' }
GtCoderNavigationElement >> deselectClasses [
	classesList deselectAll
]

{ #category : #'updating lists' }
GtCoderNavigationElement >> emptyClassList [
	classesList initializeWithClasses: #().
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
	self initializeLayout.
	self initializeContent.
	self initializeElement
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeContent [
	classesList := GtCoderClassesTreeElement multiSelection. 
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
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	self onNavigationModelChanged.
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassAdded: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self updateClassList ]
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassDeselected: anAnnouncement [
	self subclassResponsibility
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassListSelectionChanged [
	| theIndices someClasses |
	supressListChanges ifTrue: [ ^ self ].
	theIndices := classesList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	(theIndices first between: 1 and: classesList viewModel itemCount)
		ifFalse: [ ^ self ].
	(theIndices last between: 1 and: classesList viewModel itemCount)
		ifFalse: [ ^ self ].
	someClasses := classesList selectedNodes
			collect: [ :each | each value rootClass ].
	someClasses ifEmpty: [ ^ self ].
	someClasses size = 1
		ifTrue: [ self navigationModel selectClass: someClasses anyOne ]
		ifFalse: [ self navigationModel selectClasses: someClasses ]
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassModified: anAnnouncement [
	self
		suppressListChangeEventsDuring: [ self
				updateClass: anAnnouncement theClass
				inPackage: anAnnouncement package
				tag: anAnnouncement tag ]
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassRemoved: anAnnouncement [
	self subclassResponsibility
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassRenamed: anAnnouncement [
	"self
		inUIProcessDo: [ self
				suppressListChangeEventsDuring: [ self
						renameClass: anAnnouncement theClass
						oldName: anAnnouncement oldName
						newName: anAnnouncement newName
						inPackage: anAnnouncement package
						tag: anAnnouncement tag ] ]"
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassSelected: anAnnouncement [
	self subclassResponsibility
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onClassesToShowChanged: anAnnouncement [
	"Refactorings that are executed from a non-UI process should schedule an update task"
	self inUIProcessDo: [ self updateClassList ]
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
	self updateContent.
	self subscribeToNavigationModel.
	self subscribeToContent.
]

{ #category : #'api - class updates' }
GtCoderNavigationElement >> renameClass: aClass oldName: anOldName newName: aNewName inPackage: aPackage tag: aTag [
	
	classesList viewModel 
		indexOfSuchThat: [ :aTree | 
			aTree rootClass = aClass ] 
		do: [ :aTree | 
			self updateClassList.
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

{ #category : #'api - class selections' }
GtCoderNavigationElement >> selectClasses: aCollectionOfClasses [
	| aPreviousIndex newIndexes |
	aPreviousIndex := classesList selectedIndice.

	newIndexes := Array
			new: aCollectionOfClasses size
			streamContents: [ :aStream | 
				aCollectionOfClasses
					do: [ :eachClass | 
						classesList viewModel
							indexOfSuchThat: [ :each | each rootClass = eachClass ]
							do: [ :aNewIndex | aStream nextPut: aNewIndex ] ] ].

	newIndexes
		ifEmpty: [ classesList deselectAll.
			^ self ].

	newIndexes size = 1
		ifTrue: [ classesList
				selectOne: newIndexes anyOne;
				scrollToIndex: (self
						scrollIndexFromPrevious: aPreviousIndex
						current: newIndexes anyOne
						max: classesList viewModel itemCount).
			^ self ].

	newIndexes sort: [ :a :b | a < b ].
	classesList deselectAll.
	newIndexes
		do: [ :aNewIndex | classesList addToSelection: aNewIndex dueTo: nil ].
	classesList
		scrollToIndex: (self
				scrollIndexFromPrevious: aPreviousIndex
				current: newIndexes anyOne
				max: classesList viewModel itemCount)
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToClassList [
	classesList
		when: BrSelectionChanged
		do: [ :anEvent | self onClassListSelectionChanged ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToContent [
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToNavigationModel [
	| subscriptions |
	self hasNavigationModel ifFalse: [ ^ self ].

	subscriptions := {
		GtCoderNavigationClassSelected -> #onClassSelected:.
		GtCoderNavigationClassDeselected -> #onClassDeselected:.
		GtCoderNavigationClassRenamed -> #onClassRenamed:.
		GtCoderNavigationClassModified -> #onClassModified:.
		GtCoderNavigationClassesToShowChanged -> #onClassesToShowChanged:.
	}.

	subscriptions
		do: [ :sub | 
			navigationModel weak
				when: sub key
				send: sub value
				to: self ]
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressListChangeEventsDuring: aBlock [
	| anOldValue |
	anOldValue := supressListChanges.
	supressListChanges := true.
	aBlock ensure: [ supressListChanges := anOldValue ].
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
			self updateClassList.
			self updateSelectedClass ].
]

{ #category : #'updating lists' }
GtCoderNavigationElement >> updateClassList [
	"Update class list"
]

{ #category : #updating }
GtCoderNavigationElement >> updateContent [
]

{ #category : #'updating lists' }
GtCoderNavigationElement >> updateSelectedClass [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel selectedClassDo: [ :aClass | self selectClass: aClass ]
]
