"
I show a simple list of classes sorting alphabetically
"
Class {
	#name : #GtCoderNavigationClassesListElement,
	#superclass : #BrSimpleList,
	#traits : 'TGtCoderNavigationClassesHelper',
	#classTraits : 'TGtCoderNavigationClassesHelper classTrait',
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesListElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesListElement >> buildClassRow: aClass index: aRowIndex list: aListElement [
	^ BrWidgetContainer new
		layout: BlLinearLayout horizontal;
		look: BrHorizontalPaneLook new + (BrStyleCommonLook new
			default: [ :aStyle | aStyle background: BrGlamorousColors deselectedListItemColor ];
			hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredListItemColor ];
			selected: [ :aStyle | aStyle background: BrGlamorousColors selectedListItemColor ];
			pressed: [ :aStyle | aStyle background: BrGlamorousColors pressedListItemColor ];
			focused: [ :aStyle | aStyle border: (BlBorder paint: BrGlamorousColors focusedListItemBorder width: 1) ]);
		when: BlMouseDownEvent do: [ :anEvent |
			anEvent consumed: true.
			aListElement selectOne: aRowIndex dueTo: anEvent.
			aListElement requestFocus ];
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 3);
		addChild: (self buildClassLabel: aClass)
]

{ #category : #initialization }
GtCoderNavigationClassesListElement >> initialize [
	super initialize.
	
	self stencil: [ :eachClass :eachIndex :aListElement | self buildClassRow: eachClass index: eachIndex list: aListElement ]
]

{ #category : #initialization }
GtCoderNavigationClassesListElement >> initializeWithClasses: aCollectionOfClasses [	
	self items: (aCollectionOfClasses sorted: [ :classA :classB | classA name < classB name ])
]
