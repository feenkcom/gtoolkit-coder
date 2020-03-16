Class {
	#name : #GtClassCoderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Class'
}

{ #category : #'as yet unclassified' }
GtClassCoderElementExamples >> coderElementForClass [
	<gtExample>
	| aCoder aCoderElement |
	
	aCoder := GtClassCoderExamples new coderForClass.
	aCoderElement := GtClassCoderElement new classCoder: aCoder.
	
	^ aCoderElement
]
