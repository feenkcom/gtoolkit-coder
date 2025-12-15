Class {
	#name : #GtCoderNavigationBasicClassHierarchyElement,
	#superclass : #GtCoderNavigationElement,
	#category : 'GToolkit-Coder-UI-Navigation'
}

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
GtCoderNavigationBasicClassHierarchyElement >> initializeElement [
	| pane1 |
	pane1 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {self headerLabel text: 'Classes'.
					classesList}.

	self addChild: pane1
]

{ #category : #initialization }
GtCoderNavigationBasicClassHierarchyElement >> initializeLayout [
	self layout: BlLinearLayout horizontal.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicClassHierarchyElement >> onClassDeselected: aGtCoderNavigationClassDeselected [ 
	self deselectClass: aGtCoderNavigationClassDeselected theClass
]

{ #category : #'event handling' }
GtCoderNavigationBasicClassHierarchyElement >> onClassesToShowChanged: anAnnouncement [
	supressListChanges ifTrue: [ ^ self ].
	self inUIProcessDo: [ self updateClassList ]
]

{ #category : #'event handling' }
GtCoderNavigationBasicClassHierarchyElement >> onClassListSelectionChanged [
	| anIndex aSelectedItem theIndices |
	supressListChanges ifTrue: [ ^ self ].
	theIndices := classesList selectedIndices.
	theIndices ifEmpty: [ ^ self ].
	anIndex := theIndices first.
	(anIndex between: 1 and: classesList viewModel itemCount) ifFalse: [ ^ self ].
	aSelectedItem := (classesList viewModel itemAt: anIndex) value rootClass.
	self
		suppressListChangeEventsDuring: [ self navigationModel selectClass: aSelectedItem ]
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
	super onNavigationModelChanged.
	self subscribeToClassList.
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
	| withRootClasses lastIndex isWithAllSuperclasses |
	"Check that all its root classes are in the classesList (and therefore visible)."
	lastIndex := nil.
	withRootClasses := aClass withAllSuperclasses.
	isWithAllSuperclasses := withRootClasses
			allSatisfy: [ :eachClass | 
				| currentIndex newIndex |
				currentIndex := lastIndex.
				newIndex := nil.
				classesList viewModel
					indexOfSuchThat: [ :eachTree | eachTree rootClass = eachClass ]
					do: [ :eachIndex | newIndex := eachIndex ].
				lastIndex := newIndex.
				currentIndex
					ifNil: [ newIndex isNotNil ]
					ifNotNil: [ newIndex isNotNil and: [ currentIndex > newIndex ] ] ].

	"If a selected item is the same as the requested class, we keep the existing hierarchy items. 
	Like this, for example, we do not lose siblings when we drag-and-drop methods arround."
	(isWithAllSuperclasses
		and: [ classesList selectedItems
				anySatisfy: [ :eachClassTree | eachClassTree rootClass = aClass ] ])
		ifTrue: [ ^ self ].

	classesList initializeWithHierachyForClass: aClass
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> updateContent [
	self updateClassList.
	self updateSelectedClass
]
