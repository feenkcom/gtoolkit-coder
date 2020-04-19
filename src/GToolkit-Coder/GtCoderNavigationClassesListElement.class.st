"
I show a simple list of classes sorting alphabetically
"
Class {
	#name : #GtCoderNavigationClassesListElement,
	#superclass : #BrSimpleList,
	#traits : 'TGtCoderNavigationClassesHelper',
	#classTraits : 'TGtCoderNavigationClassesHelper classTrait',
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesListElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesListElement >> buildClassRow: aClass index: aRowIndex list: aListElement [
	^ BrWidgetContainer new
		viewModelDo: [ :aBrInteractiveModel |
			(aBrInteractiveModel addStates: {
				BrHoverModel new.
				BrPressModel new.
				BrSelectModel new }) ];
		layout: BlLinearLayout horizontal;
		look: BrHorizontalPaneLook new + (BrInteractiveCommonLook new
			default: [ :aWidget | aWidget background: Color transparent ];
			hovered: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor ];
			selected: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor ];
			pressed: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor slightlyDarker ]);
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
