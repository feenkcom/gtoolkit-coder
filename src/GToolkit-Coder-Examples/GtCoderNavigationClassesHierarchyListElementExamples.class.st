Class {
	#name : #GtCoderNavigationClassesHierarchyListElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyListElementExamples >> fromCollectionClasses [
	<gtExample>

	^ GtCoderNavigationClassesHierarchyListElement
		fromClasses: #'Collections-Abstract' asPackage definedClasses
]
