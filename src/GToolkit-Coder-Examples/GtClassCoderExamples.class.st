Class {
	#name : #GtClassCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'as yet unclassified' }
GtClassCoderExamples >> onBlElement [
	<gtExample>
	| aCoder |
	aCoder := GtClassCoder forClass: BlElement.
	aCoder openInInspector.
	^ aCoder
]
