Class {
	#name : #GtCoderNavigationBasicClassHierarchyElement,
	#superclass : #GtCoderNavigationElement,
	#category : #'GToolkit-Coder-UI-Navigation'
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
	classesList initializeWithHierachyForClass: aClass.
]

{ #category : #'updating lists' }
GtCoderNavigationBasicClassHierarchyElement >> updateContent [
	self updateClassList.
	self updateSelectedClass
]
