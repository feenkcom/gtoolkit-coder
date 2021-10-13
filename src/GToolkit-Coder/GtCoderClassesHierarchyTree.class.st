"
I am an inheritance hierachy tree that can be built from a collection of classes:

{{gtExample:GtCoderClassesHierarchyTreeExamples>>#fromCollectionClasses}}


"
Class {
	#name : #GtCoderClassesHierarchyTree,
	#superclass : #Object,
	#instVars : [
		'rootClass',
		'subclassTrees'
	],
	#category : 'GToolkit-Coder-Navigation - Model'
}

{ #category : #factory }
GtCoderClassesHierarchyTree class >> fromClasses: aCollectionOfClasses [
	| aRootItem theSetOfClasses theRootTrees theSubclassTrees |
	
	aRootItem := self new.
	
	theSetOfClasses := aCollectionOfClasses asSet.
	
	theRootTrees := theSetOfClasses
		reject: [ :eachClass | theSetOfClasses anySatisfy: [ :eachSuperclass | eachClass inheritsFrom: eachSuperclass ] ]
		thenCollect: [ :eachRootClass | eachRootClass -> (theSetOfClasses select: [ :eachClass | eachClass inheritsFrom: eachRootClass ]) ].
	
	theSubclassTrees := theRootTrees collect: [ :eachAssoc | (self fromClasses: eachAssoc value) rootClass: eachAssoc key ] as: Array.
	aRootItem subclassTrees: theSubclassTrees.
	^ aRootItem
]

{ #category : #factory }
GtCoderClassesHierarchyTree class >> hierarchyForClass: aClass [
	| aRootNode aCurrentNode |
	aRootNode := self new.
	
	aCurrentNode := aRootNode.
	aClass withAllSuperclasses reverseDo: [ :eachClass | 
		| aNewNode |
		aNewNode := self new rootClass: eachClass.
		aCurrentNode subclassTrees: { aNewNode }.
		aCurrentNode := aNewNode. ].

	^ aRootNode.
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> at: anIndex [
	<return: #GtCoderClassesHierarchyTree>

	^ self subclassTrees at: anIndex
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> classes [
	<return: #Collection of: #Class>
	
	^ self subclassTrees collect: [ :eachTree | eachTree rootClass ]
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> first [
	<return: #GtCoderClassesHierarchyTree>

	^ self at: 1
]

{ #category : #'gt-extension' }
GtCoderClassesHierarchyTree >> gtTreeFor: aView [
	<gtView>

	^ aView tree
		title: 'Classes';
		priority: 1;
		items: [ { self } ];
		children: [ :anItem | anItem subclassTrees ];
		expandUpTo: 1
]

{ #category : #testing }
GtCoderClassesHierarchyTree >> hasRootClass [
	<return: #Boolean>

	^ rootClass isNotNil
]

{ #category : #initialization }
GtCoderClassesHierarchyTree >> initialize [
	super initialize.
	subclassTrees := Array empty.
]

{ #category : #printing }
GtCoderClassesHierarchyTree >> printOn: aStream [
	self hasRootClass
		ifTrue: [ aStream print: self rootClass ]
		ifFalse: [ aStream nextPutAll: 'Classes' ].
	
	self size isZero
		ifFalse: [ 
			aStream
				space;
				nextPut: $(;
				print: self size;
				nextPut: $) ]
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> rootClass [
	<return: #Behavior>
	^ rootClass
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> rootClass: aClass [
	rootClass := aClass
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> size [
	<return: #Number>

	^ subclassTrees size
]

{ #category : #sorting }
GtCoderClassesHierarchyTree >> sort: aBlock [
	subclassTrees := subclassTrees sorted: [ :treeA :treeB | aBlock value: treeA rootClass value: treeB rootClass ].
	subclassTrees do: [ :eachTree | eachTree sort: aBlock ]
]

{ #category : #sorting }
GtCoderClassesHierarchyTree >> sortByClassName [
	self sort: [ :classA :classB | classA name < classB name ]
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> subclassTrees [
	<return: #Collection of: #GtCoderClassesHierarchyTree>

	^ subclassTrees
]

{ #category : #initialization }
GtCoderClassesHierarchyTree >> subclassTrees: aCollection [
	subclassTrees := aCollection
]
