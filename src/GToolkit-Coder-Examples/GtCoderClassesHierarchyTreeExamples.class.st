Class {
	#name : #GtCoderClassesHierarchyTreeExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

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
