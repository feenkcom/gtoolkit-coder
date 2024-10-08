"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically.


"
Class {
	#name : #GtCoderNavigationClassHierarchyElement,
	#superclass : #BlElement,
	#instVars : [
		'supressListChanges',
		'classesList',
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'api - class selections' }
GtCoderNavigationClassHierarchyElement >> deselectClass: aClass [
	classesList deselectAll
]

{ #category : #'api - class selections' }
GtCoderNavigationClassHierarchyElement >> deselectClasses [
	classesList deselectAll
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierarchyElement >> emptyClassList [
	classesList initializeWithClasses: #().
]

{ #category : #testing }
GtCoderNavigationClassHierarchyElement >> hasNavigationModel [
	^ self navigationModel isNotNil and: [
		self navigationModel isNavigationModel ]
]

{ #category : #'as yet unclassified' }
GtCoderNavigationClassHierarchyElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout vertical.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	classesList := GtCoderClassesTreeElement new. 

	self addChild: classesList
]

{ #category : #accessing }
GtCoderNavigationClassHierarchyElement >> navigationModel [
	<return: #GtCoderNavigationPackagesTagsClassesModel>

	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationClassHierarchyElement >> navigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	self onNavigationModelChanged.
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onClassDeselected: aGtCoderNavigationClassDeselected [ 
	self deselectClass: aGtCoderNavigationClassDeselected theClass
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onClassListSelectionChanged [
	| anIndex aSelectedItem theIndices |

	theIndices := classesList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: classesList viewModel itemCount)
		ifFalse: [ ^ self ].
	aSelectedItem := (classesList viewModel itemAt: anIndex) value rootClass.
	self navigationModel selectClass: aSelectedItem
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onClassSelected: anAnnouncement [
	| aSelectedClass |
	
	aSelectedClass := anAnnouncement theClass.
	(classesList containsClass: aSelectedClass)
		ifFalse: [ self updateClassList ].
	self selectClass: aSelectedClass
]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
	self updateContent.
	self subscribeToNavigationModel.
	self subscribeToClassList.
]

{ #category : #'private - selection' }
GtCoderNavigationClassHierarchyElement >> scrollIndexFromPrevious: aPreviousIndex current: aNewIndex max: aNumberOfItems [
	<return: #Number>
	^ (aPreviousIndex isZero or: [ aPreviousIndex >= aNewIndex ])
		ifTrue: [ aNewIndex - 5 max: 1 ]
		ifFalse: [ aNewIndex + 5 min: aNumberOfItems ].
]

{ #category : #'api - class selections' }
GtCoderNavigationClassHierarchyElement >> selectClass: aClass [
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
GtCoderNavigationClassHierarchyElement >> subscribeToClassList [
	classesList
		when: BrSelectionChanged
		do: [ :anEvent | self onClassListSelectionChanged ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> subscribeToNavigationModel [
	| subscriptions |

	self hasNavigationModel
		ifFalse: [ ^ self ].

	subscriptions := {
		GtCoderNavigationClassSelected -> #onClassSelected:.
		GtCoderNavigationClassDeselected -> #onClassDeselected:
	}.

	subscriptions
		do: [ :sub | 
			navigationModel weak
				when: sub key
				send: sub value
				to: self ]
]

{ #category : #subscriptions }
GtCoderNavigationClassHierarchyElement >> unsubscribeFromNavigationModel [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ].
]

{ #category : #'updating lists' }
GtCoderNavigationClassHierarchyElement >> updateClassList [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedClass
		ifTrue: [ self updateClassListsWith: navigationModel selectedClass ]
		ifFalse: [ self emptyClassList ]
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

{ #category : #'updating lists' }
GtCoderNavigationClassHierarchyElement >> updateSelectedClass [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel selectedClassDo: [ :aClass | self selectClass: aClass ]
]
