Class {
	#name : #GtClassCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Model'
}

{ #category : #'instance creation' }
GtClassCoderExamples >> coderForClass [
	<gtExample>
	| aCoder |

	aCoder := GtBehaviorCoder forClass: GtBehaviorCoderDummyClass.

	^ aCoder
]
