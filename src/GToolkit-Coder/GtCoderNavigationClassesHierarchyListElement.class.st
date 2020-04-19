"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically
"
Class {
	#name : #GtCoderNavigationClassesHierarchyListElement,
	#superclass : #BrSimpleTree,
	#traits : 'TGtCoderNavigationClassesHelper',
	#classTraits : 'TGtCoderNavigationClassesHelper classTrait',
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyListElement class >> fromClasses: aCollectionOfClasses [
	^ self new fromClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesHierarchyListElement >> buildClassRow: aTreeNode index: aRowIndex tree: aTreeElement [
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
		when: BlClickEvent do: [ :anEvent |
			aTreeElement selectOne: aRowIndex dueTo: anEvent.
			aTreeElement requestFocus ];
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 3 + (aTreeNode depth * 10));
		addChild: (self buildClassLabel: aTreeNode value rootClass)
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyListElement >> fromClasses: aCollectionOfClasses [
	classesTree := (GtCoderClassesHierarchyTree fromClasses: aCollectionOfClasses) sortByClassName.
	
	self items: classesTree subclassTrees children: [ :eachRope | eachRope subclassTrees ].
	self expandAll
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyListElement >> initialize [
	super initialize.
	
	self stencil: [ :aBrTreeNode :anIndex :aTreeWidget |
		self buildClassRow: aBrTreeNode index: anIndex tree: aTreeWidget ]
]
