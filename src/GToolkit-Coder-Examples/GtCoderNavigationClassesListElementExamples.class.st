Class {
	#name : #GtCoderNavigationClassesListElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesListElementExamples >> fromCollectionClasses [
	<gtExample>

	^ GtCoderNavigationClassesListElement
		fromClasses: #'Collections-Abstract' asPackage definedClasses
]
