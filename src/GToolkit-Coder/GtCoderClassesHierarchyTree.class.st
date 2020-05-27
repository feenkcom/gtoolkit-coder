"
I am an inheritance hierachy tree that can be built from a collection of classes:

${example:GtCoderClassesHierarchyTreeExamples>>#fromCollectionClasses}$
"
Class {
	#name : #GtCoderClassesHierarchyTree,
	#superclass : #Object,
	#instVars : [
		'rootClass',
		'subclassTrees'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
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

	^ self fixedSubclassTrees at: anIndex
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> classes [
	<return: #Collection of: #Class>
	
	^ self fixedSubclassTrees collect: [ :eachTree | eachTree rootClass ]
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> first [
	<return: #GtCoderClassesHierarchyTree>

	^ self at: 1
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> fixedSubclassTrees [
	<return: #Collection of: #GtCoderClassesHierarchyTree>

	^ subclassTrees
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> growingSize [
	<return: #Number>

	^ self size isZero
		ifTrue: [ self rootClass subclasses size ] 
		ifFalse: [ self size ]
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> growingSubclassTrees [
	<return: #Collection of: #GtCoderClassesHierarchyTree>

	self fixedSubclassTrees ifEmpty: [ self updateSubclasses ].
	^ self fixedSubclassTrees
]

{ #category : #'gt-extension' }
GtCoderClassesHierarchyTree >> gtFixedTreeFor: aView [
	<gtView>

	^ aView tree
		title: 'Fixed Classes';
		priority: 1;
		items: [ { self } ];
		children: [ :anItem | anItem fixedSubclassTrees ];
		expandUpTo: 1
]

{ #category : #'gt-extension' }
GtCoderClassesHierarchyTree >> gtGrowingTreeFor: aView [
	<gtView>

	^ aView tree
		title: 'Growing Classes';
		priority: 2;
		items: [ { self } ];
		children: [ :anItem | anItem growingSubclassTrees ];
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

{ #category : #initialization }
GtCoderClassesHierarchyTree >> subclassTrees: aCollection [
	subclassTrees := aCollection
]

{ #category : #updating }
GtCoderClassesHierarchyTree >> updateSubclasses [
	self rootClass hasSubclasses ifFalse: [ ^ self ].
	subclassTrees := self rootClass subclasses 
		collect: [ :eachClass |
			self class new rootClass: eachClass ]
		as: Array.
]
