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

{ #category : #'instance creation' }
GtCoderClassesHierarchyTree class >> fromClasses: aCollectionOfClasses [
	^ self new fromClasses: aCollectionOfClasses
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTree class >> hierarchyForClass: aClass [
	^ self fromClasses: (Array streamContents: [ :aStream | 
		aStream 
			nextPutAll: aClass allSuperclasses;
			nextPut: aClass;
			nextPutAll: aClass allSubclasses ] )
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

{ #category : #initialization }
GtCoderClassesHierarchyTree >> fromClasses: aCollectionOfClasses [
	| theSetOfClasses theRootTrees |
	
	theSetOfClasses := aCollectionOfClasses asSet.
	
	theRootTrees := theSetOfClasses
		reject: [ :eachClass | theSetOfClasses anySatisfy: [ :eachSuperclass | eachClass inheritsFrom: eachSuperclass ] ]
		thenCollect: [ :eachRootClass | eachRootClass -> (theSetOfClasses select: [ :eachClass | eachClass inheritsFrom: eachRootClass ]) ].
	
	rootClass := nil.
	subclassTrees := theRootTrees collect: [ :eachAssoc | (self class fromClasses: eachAssoc value) rootClass: eachAssoc key ] as: Array.
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
	^ rootClass
]

{ #category : #accessing }
GtCoderClassesHierarchyTree >> rootClass: anObject [
	rootClass := anObject
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
