Class {
	#name : #GtClassCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Behavior'
}

{ #category : #'instance creation' }
GtClassCoderExamples >> coderForClass [
	<gtExample>
	| aCoder |

	aCoder := GtClassCoder forClass: GtBehaviorCoderDummyClass.

	^ aCoder
]
