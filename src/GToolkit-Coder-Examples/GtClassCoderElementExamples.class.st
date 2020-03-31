Class {
	#name : #GtClassCoderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Behavior'
}

{ #category : #'as yet unclassified' }
GtClassCoderElementExamples >> coderElementForClass [
	<gtExample>
	| aCoder aCoderElement |
	
	aCoder := GtClassCoderExamples new coderForClass.
	aCoderElement := GtBehaviorCoderElement new classCoder: aCoder.
	
	^ aCoderElement
]
