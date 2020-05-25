"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically
"
Class {
	#name : #GtCoderNavigationClassesHierarchyTreeElement,
	#superclass : #BrSimpleTree,
	#traits : 'TGtCoderNavigationClassesHelper',
	#classTraits : 'TGtCoderNavigationClassesHelper classTrait',
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesHierarchyTreeElement >> buildClassRow: aTreeNode index: aRowIndex tree: aTreeElement [
	^ BrWidgetContainer new
		viewModelDo: [ :aBrInteractiveModel |
			(aBrInteractiveModel addStates: {
				BrHoverModel new.
				BrPressModel new.
				BrSelectModel new }) ];
		layout: BlLinearLayout horizontal;
		look: BrHorizontalPaneLook + BrGlamorousListItemLook;
		when: BlMouseDownEvent do: [ :anEvent |
			anEvent consumed: true.
			aTreeElement selectOne: aRowIndex dueTo: anEvent.
			aTreeElement requestFocus ];
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 3 + (aTreeNode depth * 10));
		addChild: (self buildClassLabel: aTreeNode value rootClass)
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initialize [
	super initialize.
	
	self stencil: [ :aBrTreeNode :anIndex :aTreeWidget |
		self buildClassRow: aBrTreeNode index: anIndex tree: aTreeWidget ]
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithClasses: aCollectionOfClasses [
	classesTree := (GtCoderClassesHierarchyTree fromClasses: aCollectionOfClasses) sortByClassName.
	
	self items: classesTree subclassTrees children: [ :eachTree | eachTree subclassTrees ].
	self expandAll
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithHierachyForClass: aClass [
	classesTree := (GtCoderClassesHierarchyTree hierarchyForClass: aClass) sortByClassName.
	
	self items: classesTree subclassTrees children: [ :eachTree | eachTree subclassTrees ].
	self expandAll
]
