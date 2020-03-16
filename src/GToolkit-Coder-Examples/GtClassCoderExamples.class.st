Class {
	#name : #GtClassCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Class'
}

{ #category : #'instance creation' }
GtClassCoderExamples >> coderForClass [
	<gtExample>
	| aCoder |

	aCoder := GtClassCoder forClass: GtClassCoderExampleClass.

	^ aCoder
]
