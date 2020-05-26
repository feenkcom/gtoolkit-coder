Class {
	#name : #GtCoderClassesHierarchyTreeExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> fixedHierarchyForSequenceableCollectionClass [
	<gtExample>
	| aHierarchyTree aSequenceableCollectionTree |
	
	aHierarchyTree := self hierarchyForSequenceableCollectionClass.
	aSequenceableCollectionTree := aHierarchyTree first first first at: 1.
	
	self assert: aSequenceableCollectionTree rootClass equals: SequenceableCollection.
	self assert: aSequenceableCollectionTree fixedSubclassTrees isEmpty.
	self assert: aSequenceableCollectionTree size equals: 0.
	
	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> fromCollectionClasses [
	<gtExample>
	| aHierarchyTree |
	
	aHierarchyTree := GtCoderClassesHierarchyTree
		fromClasses: { Collection. Array . SequenceableCollection . OrderedCollection . Set . Dictionary . OrderedDictionary }.
	
	self assert: aHierarchyTree size equals: 1.
	self assert: aHierarchyTree first classes equals: { Set . SequenceableCollection . OrderedDictionary . Dictionary }.
	self assert: (aHierarchyTree first at: 2) classes equals: { Array . OrderedCollection }.
	
	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> growingHierarchyForArrayedCollectionClass [
	<gtExample>
	| aHierarchyTree aSequenceableCollectionTree anArrayedCollection |
	
	aHierarchyTree := self growingHierarchyForSequenceableCollectionClass.
	aSequenceableCollectionTree := aHierarchyTree first first first at: 1.
	anArrayedCollection := aSequenceableCollectionTree fixedSubclassTrees 
		detect: [ :each | each rootClass = ArrayedCollection ].
	
	self assert: anArrayedCollection fixedSubclassTrees isEmpty.
	self assert: anArrayedCollection size equals: 0.
	self assert: anArrayedCollection growingSize > 0.
	

	self assert: anArrayedCollection growingSubclassTrees size > 0.
	self assert: anArrayedCollection size > 0.

	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> growingHierarchyForSequenceableCollectionClass [
	<gtExample>
	| aHierarchyTree aSequenceableCollectionTree |
	
	aHierarchyTree := self hierarchyForSequenceableCollectionClass.
	aSequenceableCollectionTree := aHierarchyTree first first first at: 1.
	
	self assert: aSequenceableCollectionTree rootClass equals: SequenceableCollection.
	self assert: aSequenceableCollectionTree fixedSubclassTrees isEmpty.
	self assert: aSequenceableCollectionTree size equals: 0.
	self assert: aSequenceableCollectionTree growingSize > 0.
	

	self assert: aSequenceableCollectionTree growingSubclassTrees size > 0.
	self assert: aSequenceableCollectionTree size > 0.

	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> hierarchyForSequenceableCollectionClass [
	<gtExample>
	| aHierarchyTree |
	
	aHierarchyTree := GtCoderClassesHierarchyTree hierarchyForClass: SequenceableCollection.
	
	self assert: aHierarchyTree size equals: 1.
	self assert: aHierarchyTree first classes equals: { Object }.
	self assert: (aHierarchyTree first at: 1) classes equals: { Collection }.
	self assert: (aHierarchyTree first first at: 1) classes equals: { SequenceableCollection }.
	
	^ aHierarchyTree
]
