Class {
	#name : #GtCoderClassesHierarchyTreeExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> fixedHierarchyForSequenceableCollectionClass [
	<gtExample>
	| aHierarchyTree aSequenceableCollectionTree |
	
	aHierarchyTree := GtCoderClassesHierarchyTree hierarchyForClass: SequenceableCollection.
	aSequenceableCollectionTree := aHierarchyTree first first first at: 1.
	
	self assert: aSequenceableCollectionTree rootClass equals: SequenceableCollection.
	self assert: aSequenceableCollectionTree subclassTrees isEmpty.
	self assert: aSequenceableCollectionTree size equals: 0.
	
	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> fromCollectionClasses [
	<gtExample>
	| aHierarchyTree |
	
	aHierarchyTree := GtCoderClassesHierarchyTree
		fromClasses: { Collection. Array . SequenceableCollection . OrderedCollection . Set . Dictionary . OrderedDictionary }.
	
	self assert: aHierarchyTree size equals: 4.
	self assert: aHierarchyTree classes asSet equals: { Set . Array. Collection . Dictionary } asSet.
	self assert: (((aHierarchyTree sort: [:a :b | a name < b name ]) at: 2) classes asSet = { OrderedDictionary . SequenceableCollection } asSet).
	
	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> growingHierarchyForArrayedCollectionClass [
	<gtExample>
	| aHierarchyTree aSequenceableCollectionTree anArrayedCollection |
	
	aHierarchyTree := self growingHierarchyForSequenceableCollectionClass.
	aSequenceableCollectionTree := aHierarchyTree first first first at: 1.
	anArrayedCollection := aSequenceableCollectionTree currentSubclassTrees 
		detect: [ :each | each rootClass = ArrayedCollection ].
	
	self assert: anArrayedCollection currentSubclassTrees isEmpty.
	self assert: anArrayedCollection currentSize equals: 0.	

	self assert: anArrayedCollection subclassTrees size > 0.
	self assert: anArrayedCollection size > 0.
	self assert: anArrayedCollection currentSubclassTrees size > 0.
	self assert: anArrayedCollection currentSize > 0.	

	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> growingHierarchyForSequenceableCollectionClass [
	<gtExample>
	| aHierarchyTree aSequenceableCollectionTree |
	
	aHierarchyTree := self hierarchyForSequenceableCollectionClass.
	aSequenceableCollectionTree := aHierarchyTree first first first at: 1.
	
	self assert: aSequenceableCollectionTree rootClass equals: SequenceableCollection.
	self assert: aSequenceableCollectionTree currentSubclassTrees isEmpty.
	self assert: aSequenceableCollectionTree currentSize equals: 0.
	self assert: aSequenceableCollectionTree size > 0.
	

	self assert: aSequenceableCollectionTree subclassTrees size > 0.
	self assert: aSequenceableCollectionTree size > 0.
	self assert: aSequenceableCollectionTree currentSubclassTrees size > 0.
	self assert: aSequenceableCollectionTree currentSize > 0.
	
	^ aHierarchyTree
]

{ #category : #'instance creation' }
GtCoderClassesHierarchyTreeExamples >> hierarchyForSequenceableCollectionClass [
	<gtExample>
	| aHierarchyTree |
	
	aHierarchyTree := GtCoderGrowingClassesHierarchyTree hierarchyForClass: SequenceableCollection.
	
	self assert: aHierarchyTree size equals: 1.
	self assert: aHierarchyTree first classes equals: { Object }.
	self assert: (aHierarchyTree first at: 1) classes equals: { Collection }.
	self assert: (aHierarchyTree first first at: 1) classes equals: { SequenceableCollection }.
	
	^ aHierarchyTree
]
