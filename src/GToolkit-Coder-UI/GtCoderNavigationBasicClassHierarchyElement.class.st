Class {
	#name : #GtCoderNavigationBasicClassHierarchyElement,
	#superclass : #BlElement,
	#instVars : [
		'classesList',
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'api - class selections' }
GtCoderNavigationBasicClassHierarchyElement >> deselectClass: aClass [
	classesList deselectAll
]

{ #category : #'api - class selections' }
GtCoderNavigationBasicClassHierarchyElement >> deselectClasses [
	classesList deselectAll
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> emptyClassList [
	classesList initializeWithClasses: #().
]

{ #category : #testing }
GtCoderNavigationBasicClassHierarchyElement >> hasNavigationModel [
	^ self navigationModel isNotNil and: [
		self navigationModel isNavigationModel ]
]

{ #category : #initialization }
GtCoderNavigationBasicClassHierarchyElement >> headerLabel [
	| label |
	label := BrLabel new.
	label
		aptitude: (BrGlamorousLabelAptitude new
				fontSize: 12;
				foreground: Color gray).
	^ label
]

{ #category : #initialization }
GtCoderNavigationBasicClassHierarchyElement >> initialize [
	| pane1 |
	super initialize.
	
	self layout: BlLinearLayout horizontal.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	classesList := GtCoderClassesTreeElement new.
	
	pane1 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {
				self headerLabel text: 'Classes'.
				classesList }.
	
	self addChild: pane1
]

{ #category : #accessing }
GtCoderNavigationBasicClassHierarchyElement >> navigationModel [
	<return: #GtCoderNavigationPackagesTagsClassesModel>

	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationBasicClassHierarchyElement >> navigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	self onNavigationModelChanged.
]

{ #category : #'event handling' }
GtCoderNavigationBasicClassHierarchyElement >> onClassDeselected: aGtCoderNavigationClassDeselected [ 
	self deselectClass: aGtCoderNavigationClassDeselected theClass
]

{ #category : #'event handling' }
GtCoderNavigationBasicClassHierarchyElement >> onClassListSelectionChanged [
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
GtCoderNavigationBasicClassHierarchyElement >> onClassSelected: anAnnouncement [
	| aSelectedClass |
	
	aSelectedClass := anAnnouncement theClass.
	(classesList containsClass: aSelectedClass)
		ifFalse: [ self updateClassList ].
	self selectClass: aSelectedClass
]

{ #category : #'event handling' }
GtCoderNavigationBasicClassHierarchyElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
	self updateContent.
	self subscribeToNavigationModel.
	self subscribeToClassList.
]

{ #category : #'private - selection' }
GtCoderNavigationBasicClassHierarchyElement >> scrollIndexFromPrevious: aPreviousIndex current: aNewIndex max: aNumberOfItems [
	<return: #Number>
	^ (aPreviousIndex isZero or: [ aPreviousIndex >= aNewIndex ])
		ifTrue: [ aNewIndex - 5 max: 1 ]
		ifFalse: [ aNewIndex + 5 min: aNumberOfItems ].
]

{ #category : #'api - class selections' }
GtCoderNavigationBasicClassHierarchyElement >> selectClass: aClass [
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
GtCoderNavigationBasicClassHierarchyElement >> subscribeToClassList [
	classesList
		when: BrSelectionChanged
		do: [ :anEvent | self onClassListSelectionChanged ]
]

{ #category : #subscriptions }
GtCoderNavigationBasicClassHierarchyElement >> subscribeToNavigationModel [
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
GtCoderNavigationBasicClassHierarchyElement >> unsubscribeFromNavigationModel [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ].
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> updateClassList [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedClass
		ifTrue: [ self updateClassListsWith: navigationModel selectedClass ]
		ifFalse: [ self emptyClassList ]
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> updateClassListsWith: aClass [
	classesList initializeWithHierachyForClass: aClass.
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> updateContent [
	self updateClassList.
	self updateSelectedClass
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> updateSelectedClass [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel selectedClassDo: [ :aClass | self selectClass: aClass ]
]
