"
I am used by ${class:GtFilterRunExampleButtonLookExamples}$ to exemplify ${class:GtFilterRunExampleButtonLook|expanded=true|show=#gtSubclassesFor:|height=150}$ subclasses:
"
Class {
	#name : #GtFilterRunExampleButtonLookDummyExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters - UI'
}

{ #category : #examples }
GtFilterRunExampleButtonLookDummyExamples >> one [
	<gtExample>
	^ 1
]

{ #category : #accessing }
GtFilterRunExampleButtonLookDummyExamples >> three [
	<gtExample>
	<noTest>
	^ 1/0
]

{ #category : #accessing }
GtFilterRunExampleButtonLookDummyExamples >> two [
	<gtExample>
	<noTest>
	self assert: false.
]
