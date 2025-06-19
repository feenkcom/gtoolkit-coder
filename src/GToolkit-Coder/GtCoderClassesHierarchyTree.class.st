"
I am an inheritance hierachy tree that can be built from a collection of classes:

{{gtExample:GtCoderClassesHierarchyTreeExamples>>#fromCollectionClasses}}


"
Class {
	#name : #GtCoderClassesHierarchyTree,
	#superclass : #Object,
	#instVars : [
		'rootClass',
		'subclassTrees',
		'rootClassName'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #factory }
GtCoderClassesHierarchyTree class >> fromClasses: aCollectionOfClasses [

	| aRootItem theSetOfClasses classToTree |
	aRootItem := self new.
	theSetOfClasses := aCollectionOfClasses asSet.
	classToTree := Dictionary new.
	theSetOfClasses do: [ :each | 
		classToTree
			at: each
			put: (self new rootClass: each) ].
	theSetOfClasses do: [ :each | 
		classToTree
			at: each superclass
			ifPresent: [ :superTree | 
			superTree subclassTrees add: (classToTree at: each) ]
			ifAbsent: [ aRootItem subclassTrees add: (classToTree at: each) ] ].
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

{ #category : #comparing }
GtCoderClassesHierarchyTree >> = anObject [
	^ anObject class = self class
		and: [ self rootClass = anObject rootClass
				and: [ self rootClassName = anObject rootClassName
						and: [ self subclassTrees = anObject subclassTrees ] ] ]
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

{ #category : #testing }
GtCoderClassesHierarchyTree >> containsClass: aClass [
	rootClass = aClass
		ifTrue: [ ^ true ].

	^ self subclassTrees anySatisfy: [ :eachTree | eachTree containsClass: aClass ]
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

{ #category : #comparing }
GtCoderClassesHierarchyTree >> hash [
	^ self rootClass hash bitXor: self subclassTrees hash
]

{ #category : #testing }
GtCoderClassesHierarchyTree >> hasRootClass [
	<return: #Boolean>

	^ rootClass isNotNil
]

{ #category : #initialization }
GtCoderClassesHierarchyTree >> initialize [
	super initialize.
	subclassTrees := OrderedCollection new
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
	rootClass := aClass.
	rootClassName := rootClass name
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> rootClassName [
	^ rootClassName
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
