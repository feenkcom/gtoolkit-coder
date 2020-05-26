"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically
"
Class {
	#name : #GtCoderNavigationClassesHierarchyTreeElement,
	#superclass : #BrSimpleTree,
	#instVars : [
		'classesTree',
		'listItemStencilBuilder'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesHierarchyTreeElement >> buildClassRow: aTreeNode index: aRowIndex tree: aTreeElement [
	^ listItemStencilBuilder new
		node: aTreeNode;
		index: aRowIndex;
		widget: aTreeElement;
		asElement
]

{ #category : #'private - ui' }
GtCoderNavigationClassesHierarchyTreeElement >> expandClass: aClass [
	| aClassDepth |
	aClassDepth := 0.
	aClass
		allSuperclassesDo: [ :eachClass | aClassDepth := aClassDepth + 1 ].
	self expandUpTo: aClassDepth + 1
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initialize [
	super initialize.
	self stencil: GtCoderNonExpandableClassTreeItemStencilBuilder new.
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithClasses: aCollectionOfClasses [
	classesTree := (GtCoderClassesHierarchyTree fromClasses: aCollectionOfClasses) 
		sortByClassName.
	self 
		items: classesTree fixedSubclassTrees 
		children: [ :eachTree | eachTree fixedSubclassTrees ].
	self expandAll
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithHierachyForClass: aClass [
	classesTree := (GtCoderClassesHierarchyTree hierarchyForClass: aClass)
		sortByClassName.
	self
		items: classesTree growingSubclassTrees
		children: [ :eachTree | eachTree growingSubclassTrees ].
	self expandClass: aClass
]
