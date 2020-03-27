Class {
	#name : #GtClassCoderHeaderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Class'
}

{ #category : #'examples - header' }
GtClassCoderHeaderElementExamples >> coderHeaderElementForClass [
	<gtExample>
	| aCoder aCoderHeaderElement |

	aCoder := GtClassCoderExamples new coderForClass.
	aCoder forClass: BrButton.
	aCoderHeaderElement := GtClassCoderHeaderElement new classCoder: aCoder.
	aCoderHeaderElement expand.

	^ aCoderHeaderElement
]
