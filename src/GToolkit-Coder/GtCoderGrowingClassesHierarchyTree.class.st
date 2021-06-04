"
I am an inheritance hierachy tree that can be built from a collection of classes.
I automatically compute subclasses on demand.

{{gtExample:GtCoderClassesHierarchyTreeExamples>>#growingHierarchyForSequenceableCollectionClass}}


"
Class {
	#name : #GtCoderGrowingClassesHierarchyTree,
	#superclass : #GtCoderClassesHierarchyTree,
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #accessing }
GtCoderGrowingClassesHierarchyTree >> currentSize [
	<return: #Number>

	^ self currentSubclassTrees size
]

{ #category : #accessing }
GtCoderGrowingClassesHierarchyTree >> currentSubclassTrees [
	<return: #Collection of: #GtCoderClassesHierarchyTree>

	^ subclassTrees
]

{ #category : #'gt-extension' }
GtCoderGrowingClassesHierarchyTree >> gtFixedTreeFor: aView [
	<gtView>

	^ aView tree
		title: 'Fixed Classes';
		priority: 1;
		items: [ { self } ];
		children: [ :anItem | anItem currentSubclassTrees ];
		expandUpTo: 1
]

{ #category : #'gt-extension' }
GtCoderGrowingClassesHierarchyTree >> gtTreeFor: aView [
	<gtView>
	^ (super gtTreeFor: aView)
		title: 'Growing Classes';
		priority: 2
]

{ #category : #accessing }
GtCoderGrowingClassesHierarchyTree >> size [
	<return: #Number>

	^ super size isZero
		ifTrue: [ self rootClass subclasses size ] 
		ifFalse: [ super size ]
]

{ #category : #accessing }
GtCoderGrowingClassesHierarchyTree >> subclassTrees [
	<return: #Collection of: #GtCoderClassesHierarchyTree>

	super subclassTrees ifEmpty: [ self updateSubclasses ].
	^ super subclassTrees
]

{ #category : #updating }
GtCoderGrowingClassesHierarchyTree >> updateSubclasses [
	self rootClass instanceSide hasSubclasses ifFalse: [ ^ self ].
	subclassTrees := (self rootClass subclasses
		reject: #isClassSide) 
			collect: [ :eachClass |
				self class new rootClass: eachClass ]
			as: Array.
]
