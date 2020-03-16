Class {
	#name : #GtClassCoderHeaderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Class'
}

{ #category : #'as yet unclassified' }
GtClassCoderHeaderElementExamples >> coderHeaderElementForClass [
	<gtExample>
	| aCoder aCoderHeaderElement |

	aCoder := GtClassCoderExamples new coderForClass.
	aCoderHeaderElement := GtClassCoderHeaderElement new classCoder: aCoder.

	^ aCoderHeaderElement
]
