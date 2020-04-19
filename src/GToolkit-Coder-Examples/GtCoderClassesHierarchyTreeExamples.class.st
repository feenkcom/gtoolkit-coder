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
